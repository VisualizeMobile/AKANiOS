//
//  AKMainListTableViewController.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 07/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKMainListViewController.h"
#import "AKMainTableViewCell.h"
#import "AKDetailViewController.h"
#import "AKInfoViewController.h"
#import "AKParliamentaryDao.h"
#import "AKToolBar.h"
#import "AKUtil.h"
#import "AKSettingsManager.h"
#import "AKConfigViewController.h"
#import "AKWebServiceConsumer.h"
#import "AKQuotaDao.h"
#import "MBProgressHUD.h"
#import "AKStatisticDao.h"
#import "AKQuota.h"
#import "Reachability.h"

const NSInteger TAG_FOR_VIEW_TO_REMOVE_SEARCH_DISPLAY_GAP = 1234567;

@interface AKMainListViewController ()

@property (nonatomic) UISearchDisplayController *searchController;
@property (nonatomic) NSArray *parliamentaryArray;
@property (nonatomic) NSArray *parliamentaryNicknameFilteredArray;
@property (nonatomic) BOOL viewByRankEnabled;
@property (nonatomic) BOOL viewFollowedEnabled;
@property (nonatomic) BOOL searchEnabled;
@property (nonatomic) AKToolBar *toolBar;
@property (nonatomic) AKParliamentaryDao *parliamentaryDao;
@property (nonatomic) AKQuotaDao *quotaDao;
@property (nonatomic) AKStatisticDao *statisticDao;
@property (nonatomic) AKSettingsManager *settingsManager;
@property (nonatomic) AKWebServiceConsumer *webService;
@property (nonatomic) NSMutableArray *parliamentaryToBeNotifiedArray;
@property (nonatomic) MBProgressHUD *hud;

@property (nonatomic) BOOL lastOrientationWasLadscape;
@property (nonatomic) BOOL autolayoutCameFromSearchDismiss;
@property (nonatomic) BOOL needsToHideSearchBar;
@property (nonatomic) BOOL lastTableViewForRemoveGapWasOfSearchDisplay;



@end

@implementation AKMainListViewController


#pragma mark - View controller methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure initial data
    self.title = @"Parlamentares";
    
    self.viewByRankEnabled = NO;
    self.viewFollowedEnabled = NO;
    self.searchEnabled = NO;
    self.lastTableViewForRemoveGapWasOfSearchDisplay = NO;
    self.parliamentaryDao = [AKParliamentaryDao getInstance];
    self.quotaDao = [AKQuotaDao getInstance];
    self.parliamentaryArray = [self.parliamentaryDao getAllParliamentary];
    self.parliamentaryNicknameFilteredArray = [NSArray array];
    self.statisticDao = [AKStatisticDao getInstance];
    self.parliamentaryToBeNotifiedArray = [NSMutableArray array];
    
    self.settingsManager = [AKSettingsManager sharedManager];
    
    self.lastOrientationWasLadscape = NO;
    self.autolayoutCameFromSearchDismiss = NO;
    self.needsToHideSearchBar = YES;
    
    // Configure Toolbar
    self.toolBar = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AKToolBar class]) owner:self options:nil] firstObject];
    
    [self.toolBar.followedButton addTarget:self action:@selector(viewFollowed:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar.rankButton addTarget:self action:@selector(viewByRank:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar.searchButton addTarget:self action:@selector(searchByName:) forControlEvents:UIControlEventTouchUpInside];
    
    self.toolBarContainer.backgroundColor = self.toolBar.backgroundColor = [AKUtil color3];

    [self.toolBarContainer addSubview:self.toolBar];
    
    [self.toolBar.rankButton setImage:[UIImage imageNamed:@"rankingdesativado"] forState:UIControlStateNormal];
    [self.toolBar.rankButton setImage:[UIImage imageNamed:@"rankingativado"] forState:UIControlStateSelected];
    [self.toolBar.followedButton setImage:[UIImage imageNamed:@"seguidosdesativado"] forState:UIControlStateNormal];
    [self.toolBar.followedButton setImage:[UIImage imageNamed:@"seguidosativado"] forState:UIControlStateSelected];
    [self.toolBar.searchButton setImage:[UIImage imageNamed:@"buscadesativada"] forState:UIControlStateNormal];
    [self.toolBar.searchButton setImage:[UIImage imageNamed:@"buscaativada"] forState:UIControlStateSelected];
    

    // Configure navigation bar
    UIButton* configButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    [configButton setBackgroundImage:[UIImage imageNamed:@"configuracao"] forState:UIControlStateNormal];
    [configButton addTarget:self action:@selector(configuration:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:configButton];
    
    UIButton* infoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [infoButton setBackgroundImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    // Configure search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    searchBar.clipsToBounds = NO;
    searchBar.delegate = self;
    searchBar.placeholder = @"Filtre por nome";

    self.tableView.tableHeaderView = searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    
    if(self.idParliamentaryFromNotification != nil) {
        AKDetailViewController *detailController = [[AKDetailViewController alloc] init];
        detailController.parliamentary = [self.parliamentaryDao getParliamentaryWithId:self.idParliamentaryFromNotification];
        self.idParliamentaryFromNotification = nil;
        [self.navigationController pushViewController:detailController animated:YES];
    }
    
    // Web service
    self.webService = [[AKWebServiceConsumer alloc] init];

    [self.webService downloadDataWithPath:@"/versao" andFinishBlock:^(NSArray *jsonArray, BOOL success, BOOL isConnectionError) {
        if(success) {
            NSNumber *serverDataUpdateVersion = jsonArray[0][@"fields"][@"versaoupdate"];
            if(([serverDataUpdateVersion integerValue] > [self.settingsManager getDataUpdateVersion])
               || [self.parliamentaryDao getAllParliamentary].count == 0) {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self updateLocalDatabase: [serverDataUpdateVersion integerValue]];
                });
            }
        } else {
            [self showError:isConnectionError];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillLayoutSubviews {
    self.needsToHideSearchBar = [self isSearchBarHidden];
}

-(void) viewWillAppear:(BOOL)animated {
    
    //
    [self applyAllDefinedFiltersAndSort];
    [self.tableView reloadData];
    
    //
    [self transformNavigationBarButtons];
    
    if (self.searchController.active)
    {
        [self filterArrayByText:self.searchController.searchBar.text];
        [self.searchController.searchResultsTableView reloadData];
    }
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGRect toolbarFrame = self.toolBar.frame;    
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        toolbarFrame.origin.x = self.view.center.x - toolbarFrame.size.width/2 ;
    }  if(UIInterfaceOrientationIsPortrait(orientation)) {
        toolbarFrame.origin.x = self.toolBarContainer.frame.origin.x;
    }
    
    self.toolBar.frame = toolbarFrame;
}

-(void)viewDidLayoutSubviews {
    static BOOL firstTime = YES;
    
    if(firstTime == YES || self.needsToHideSearchBar) {
        if(self.lastOrientationWasLadscape) {
            [self.tableView setContentOffset: CGPointMake(0, -8)];
        } else {
            [self.tableView setContentOffset: CGPointMake(0, -20)];
        }
        
        firstTime = NO;
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGRect toolbarFrame = self.toolBar.frame;
    
    if(UIInterfaceOrientationIsLandscape(orientation))
        self.lastOrientationWasLadscape = YES;
    else
        self.lastOrientationWasLadscape = NO;
    
    if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation) && UIInterfaceOrientationIsPortrait(orientation)) {
        toolbarFrame.origin.x = self.view.center.y - toolbarFrame.size.width/2 ;
    } else if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
        toolbarFrame.origin.x = self.toolBarContainer.frame.origin.x;
    }
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.toolBar.frame = toolbarFrame;
                     }
                     completion:nil];

}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self transformNavigationBarButtons];
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchController.searchResultsTableView)
        return self.parliamentaryNicknameFilteredArray.count;
    else
        return self.parliamentaryArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    AKMainTableViewCell *cell = (AKMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AKMainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.quotaSum.hidden = cell.rankPosition.hidden = !self.viewByRankEnabled;
    
    cell.parliamentaryPhoto.image = [UIImage imageNamed:@"placeholder_foto"];
    
    AKParliamentary *parliamentary = nil;
    
    if (tableView == self.searchController.searchResultsTableView)
    {
        parliamentary = self.parliamentaryNicknameFilteredArray[indexPath.row];
    } else {
        parliamentary = self.parliamentaryArray[indexPath.row];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *parliamentaryPhotoFilePath = [NSString stringWithFormat:@"%@/%@.jpg", [AKSettingsManager photoCacheDirPath], parliamentary.idParliamentary];
    BOOL photoExistsInCache = [fileManager fileExistsAtPath:parliamentaryPhotoFilePath];
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    // Have photo in DB
    if (parliamentary.photoParliamentary != nil) {
        cell.parliamentaryPhoto.image=[UIImage imageWithData:parliamentary.photoParliamentary];
    // Has WiFi OR dont have photo in cache
    } else if(reachability.currentReachabilityStatus == ReachableViaWiFi || photoExistsInCache == NO) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.camara.gov.br/internet/deputado/bandep/%@.jpg", parliamentary.idParliamentary]]];

            if (photoData) {
                UIImage *image = [UIImage imageWithData:photoData];
                
                if (image) {
                    [photoData writeToFile:parliamentaryPhotoFilePath atomically:YES];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.parliamentaryDao updateParliamentary:parliamentary.idParliamentary withPhoto:photoData];
                        AKMainTableViewCell *updateCell = (AKMainTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                            updateCell.parliamentaryPhoto.image = image;
                    });
                }
            }
        });
    // Have photo in cache
    } else if(photoExistsInCache) {
        NSData *photoData = [NSData dataWithContentsOfFile:parliamentaryPhotoFilePath];
        [self.parliamentaryDao updateParliamentary:parliamentary.idParliamentary withPhoto:photoData];
        cell.parliamentaryPhoto.image = [UIImage imageWithData:photoData];
    }
    
    cell.parliamentaryName.text = parliamentary.nickName;
    cell.partyLabel.text=parliamentary.party;
    cell.ufLabel.text=parliamentary.uf;
    cell.rankPosition.text=[NSString stringWithFormat:@"%@º", parliamentary.posRanking];
    if ([parliamentary.followed isEqual:@1]) {
        [cell.followedButton setImage:[UIImage imageNamed:@"seguido"] forState:UIControlStateNormal];
    }
    else{
        [cell.followedButton setImage:[UIImage imageNamed:@"seguidooff"] forState:UIControlStateNormal];
    }
    
    NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    numberFormatter.minimumFractionDigits = 2;
    NSString *formattedNumberString = [numberFormatter stringFromNumber:parliamentary.valueRanking];
    
    cell.quotaSum.text=[NSString stringWithFormat:@"R$ %@",formattedNumberString];
    
    [cell.followedButton addTarget:self action:@selector(followParliementary:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewByRankEnabled)
        return 100;
    else
        return 70;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AKDetailViewController *detailController = [[AKDetailViewController alloc] init];
    
    if (self.searchController.active)
        detailController.parliamentary = [self.parliamentaryNicknameFilteredArray objectAtIndex:indexPath.row];
    else
    
        detailController.parliamentary = [self.parliamentaryArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Search Bar Delegate

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self filterArrayByText:searchText];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[[self.searchController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.001);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        for (UIView* v in self.searchController.searchResultsTableView.subviews) {
            if ([v isKindOfClass: [UILabel class]] &&
                [[(UILabel*)v text] isEqualToString:@"No Results"]) {
                ((UILabel*)v).text = @"Sem resultados.";
                break;
            }
        }
    });

    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    self.searchController.searchResultsTableView.delegate = self;
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    [self.tableView reloadData];
    self.searchEnabled = NO;
    [self.toolBar.searchButton setSelected:self.searchEnabled];
    self.toolBar.searchLabel.textColor = [AKUtil color1];
    
    self.autolayoutCameFromSearchDismiss = YES;
    
    // TO REMOVE WHITE GAP AFTER SEARCH DISPLAY DISMISS
    if(self.lastTableViewForRemoveGapWasOfSearchDisplay)
        [[self.searchController.searchResultsTableView viewWithTag:TAG_FOR_VIEW_TO_REMOVE_SEARCH_DISPLAY_GAP] removeFromSuperview];
    else
      [[self.tableView viewWithTag:TAG_FOR_VIEW_TO_REMOVE_SEARCH_DISPLAY_GAP] removeFromSuperview];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    // TO REMOVE WHITE GAP AFTER SEARCH DISPLAY DISMISS
    UIView *topTableViewBG = [[UIView alloc] initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 64)];
    topTableViewBG.backgroundColor = [AKUtil color1];
    topTableViewBG.tag = TAG_FOR_VIEW_TO_REMOVE_SEARCH_DISPLAY_GAP;
    
    if(controller.searchBar.text.length > 0) {
        self.lastTableViewForRemoveGapWasOfSearchDisplay = YES;
        [self.searchController.searchResultsTableView insertSubview:topTableViewBG belowSubview:self.searchController.searchBar];
    } else {
        self.lastTableViewForRemoveGapWasOfSearchDisplay = NO;
        [self.tableView insertSubview:topTableViewBG belowSubview:self.tableView.tableHeaderView];
    }
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    
    UIButton *cancelButton;
    UIView *topView = self.searchController.searchBar.subviews[0];
    for (UIView *subView in topView.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
            cancelButton = (UIButton*)subView;
            [cancelButton setTitle:@"Cancelar" forState:UIControlStateNormal];
        }
    }
    
    return YES;
}

#pragma mark - Actions

-(void) searchByName:(id) sender {
    self.searchEnabled = !self.searchEnabled;
    [self.toolBar.searchButton setSelected:self.searchEnabled];
    if (self.searchEnabled)
        self.toolBar.searchLabel.textColor = [AKUtil color5];
    else
        self.toolBar.searchLabel.textColor = [AKUtil color1];
    
    if([self isSearchBarHidden] == NO) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int)(0.3 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if([self isSearchBarHidden]) {
            UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
            if(UIInterfaceOrientationIsPortrait(orientation))
                [self.tableView setContentOffset: CGPointMake(0, -64) animated:YES];
            else
                [self.tableView setContentOffset: CGPointMake(0, -52) animated:YES];
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int)(0.3 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.searchController.searchBar becomeFirstResponder];
            });
        } else {
            [self.searchController.searchBar becomeFirstResponder];
        }
    });
}

-(void)followParliementary:(UIButton*) sender
{
    if([sender.superview.superview.superview isKindOfClass:[AKMainTableViewCell class]]) {
        AKMainTableViewCell *cell = ((AKMainTableViewCell*)sender.superview.superview.superview);
        AKParliamentary *parliamentary = nil;
        if (self.searchController.active)
        {
            NSIndexPath *indexPath = [self.searchController.searchResultsTableView indexPathForCell:cell];
            parliamentary = self.parliamentaryNicknameFilteredArray[indexPath.row];
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            parliamentary = self.parliamentaryArray[indexPath.row];
        }

        if (self.viewFollowedEnabled) {
            [self.parliamentaryDao updateFollowedByIdParliamentary:parliamentary.idParliamentary andFollowedValue:@0];

            [parliamentary setFollowed:@0];
            
            [self applyAllDefinedFiltersAndSort];
            
            [sender setImage:[UIImage imageNamed:@"seguidooff"] forState:UIControlStateNormal];
            
            [self.quotaDao deleteQuotasByIdParliamentary:parliamentary.idParliamentary];
            
            if (self.searchController.active) {
                [self filterArrayByText:self.searchController.searchBar.text];
                //NSLog(@"%@",self.searchController.searchBar.text);
                NSIndexPath *cellIndex = [self.searchController.searchResultsTableView indexPathForCell:cell];
                [self.searchController.searchResultsTableView deleteRowsAtIndexPaths:@[cellIndex] withRowAnimation:UITableViewRowAnimationFade];
            }
            else {NSIndexPath *cellIndex = [self.tableView indexPathForCell:cell];
                [self.tableView deleteRowsAtIndexPaths:@[cellIndex] withRowAnimation:UITableViewRowAnimationFade];
            }
        } else {
            if ([parliamentary.followed isEqual:@1]) {
                [sender setImage:[UIImage imageNamed:@"seguidooff"] forState:UIControlStateNormal];
                
                [parliamentary setFollowed:@0];

                [self.parliamentaryDao updateFollowedByIdParliamentary:parliamentary.idParliamentary andFollowedValue:@0];
                
                [self.quotaDao deleteQuotasByIdParliamentary:parliamentary.idParliamentary];
            }
            else{
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.hud.color = [AKUtil color1clear];
                self.hud.detailsLabelFont = [UIFont boldSystemFontOfSize:14];
                self.hud.detailsLabelColor = [AKUtil color4];
                self.hud.detailsLabelText = [NSString stringWithFormat:@"Parlamentar %@ seguido", parliamentary.nickName];
                self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                self.hud.mode = MBProgressHUDModeCustomView;
                
                [self.hud show:YES];
                [self.hud hide:YES afterDelay:1.75];
                self.hud = nil;
                
                [sender setImage:[UIImage imageNamed:@"seguido"] forState:UIControlStateNormal];

                [parliamentary setFollowed:@1];
                [self.parliamentaryDao updateFollowedByIdParliamentary:parliamentary.idParliamentary andFollowedValue:@1];
                
                [self updateQuotasForParliamentary:parliamentary.idParliamentary];
            }
        }
    }
}

-(void) viewByRank:(id) sender {
    self.viewByRankEnabled = !self.viewByRankEnabled;
    [self.toolBar.rankButton setSelected:self.viewByRankEnabled];
    if (self.viewByRankEnabled)
        self.toolBar.rankLabel.textColor = [AKUtil color5];
    else
        self.toolBar.rankLabel.textColor = [AKUtil color1];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void) viewFollowed:(id) sender {
     self.viewFollowedEnabled = !self.viewFollowedEnabled;
    [self.toolBar.followedButton setSelected:self.viewFollowedEnabled];
    if (self.viewFollowedEnabled)
        self.toolBar.followedLabel.textColor = [AKUtil color5];
    else
        self.toolBar.followedLabel.textColor = [AKUtil color1];
    
    [self applyAllDefinedFiltersAndSort];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void) configuration:(id) sender {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[AKConfigViewController alloc] init]];
    nav.navigationBar.barTintColor = [AKUtil color1];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [AKUtil color4]};
    nav.navigationBar.tintColor = [AKUtil color4];

    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

-(void) infoScreen:(id) sender {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[AKInfoViewController alloc] init]];
    
    nav.navigationBar.barTintColor = [AKUtil color1];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [AKUtil color4]};
    nav.navigationBar.tintColor = [AKUtil color4];

    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Custom methods

-(void) updateLocalDatabase:(NSInteger)serverDataUpdateVersion  {
    // Save followed ids and your quota updates version
    
    NSMutableDictionary *followedParliamentaryIdsAndUpdatesVersion = [NSMutableDictionary dictionary];
    for(AKParliamentary *p in [self.parliamentaryDao getAllFollowedPartliamentary]) {
        NSMutableDictionary *quotasUpdateVersion = [NSMutableDictionary dictionary];

        for(AKQuota *q in [self.quotaDao getQuotaByIdParliamentary:p.idParliamentary])
            quotasUpdateVersion[q.idQuota] = q.idUpdate;
            
        followedParliamentaryIdsAndUpdatesVersion[p.idParliamentary] = quotasUpdateVersion;
    }
    
    [NSKeyedArchiver archiveRootObject:followedParliamentaryIdsAndUpdatesVersion toFile:[self getTemporaryFilePath]];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [AKUtil color1clear];
    self.hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15];
    self.hud.detailsLabelColor = [AKUtil color4];
    self.hud.detailsLabelText = @"Atualizando os dados dos parlamentares";
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.webService downloadDataWithPath:@"/parlamentar" andFinishBlock:^(NSArray *jsonArray, BOOL success, BOOL isConnectionError) {
            
            if(success) {
                
                [self.parliamentaryDao deleteAllPariamentary];
                [self.quotaDao deleteAllQuota];
                [self.statisticDao deleteAllStatistic];
                
                NSNumber * idParliamentary;
                NSString * nickName;
                NSString * party;
                NSNumber * posRanking;
                NSString * uf;
                NSNumber * valueRanking;
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
                
                for(NSDictionary *jsonDict in jsonArray) {
                    idParliamentary = jsonDict[@"pk"];
                    valueRanking = [NSDecimalNumber decimalNumberWithString:jsonDict[@"fields"][@"valor"]];
                    posRanking = jsonDict[@"fields"][@"ranking"];
                    uf = jsonDict[@"fields"][@"ufparlamentar"];
                    party = jsonDict[@"fields"][@"partidoparlamentar"];
                    nickName = jsonDict[@"fields"][@"nomeparlamentar"];
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.parliamentaryDao insertParliamentaryWithNickName:nickName andIdParliamentary:idParliamentary andParty:party andPosRanking:posRanking andUf:uf andValueRanking:[NSDecimalNumber decimalNumberWithDecimal:[valueRanking decimalValue]] andFollowed:@0];
                    });
                }
                
                
                self.parliamentaryArray = [self.parliamentaryDao getAllParliamentary];
                self.parliamentaryNicknameFilteredArray = [NSArray array];
                [self applyAllDefinedFiltersAndSort];
                
                NSDictionary *recoveredfollowedParliamentaryIdsAndUpdatesVersion = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getTemporaryFilePath]];
                
                // Update quotas
                for(NSNumber *idParliamentary in [recoveredfollowedParliamentaryIdsAndUpdatesVersion allKeys]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.parliamentaryDao updateFollowedByIdParliamentary:idParliamentary andFollowedValue:@1];
                    });
                
                    [self updateQuotasForParliamentary:idParliamentary];
                }
                
                [self updateStatistics];
                
                [self.settingsManager setDataUpdateVersion:serverDataUpdateVersion];
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.tableView reloadData];
                    [self.hud hide:YES afterDelay:0.5f];
                    self.hud = nil;
                });
                
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.hud hide:YES];
                    self.hud = nil;
                });
                
                [self showError:isConnectionError];
            }
        }];
    });
    
}

-(void) updateStatistics{
    [self.webService downloadDataWithPath:@"/cota/media-maximo-por-periodo" andFinishBlock:^(NSArray *jsonArray, BOOL success, BOOL isConnectionError) {
        if(success) {
            NSNumber * numQuota;
            NSDecimalNumber * maxValue;
            NSDecimalNumber * average;
            NSNumber * year;
            NSNumber * month;
            
            
            for(NSDictionary *jsonDict in jsonArray) {
                
                NSString *maxString = [NSString stringWithFormat:@"%.2f",[jsonDict[@"valor_maximo"] doubleValue]];
                maxValue = [NSDecimalNumber decimalNumberWithString: maxString];
               // NSLog(@"valor maximo %@", maxValue);
                NSString *averageString = [NSString stringWithFormat:@"%.2f",[jsonDict[@"valor_medio"] doubleValue]];
                average = [NSDecimalNumber decimalNumberWithString: averageString];
               // NSLog(@"valor medio %@", average);
                numQuota = jsonDict[@"numsubcota"];
                month = jsonDict[@"mes"];
                year = jsonDict[@"ano"];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.statisticDao insertStatisticWithNumQuota:numQuota andMonth:month andYear:year andMaxValue:maxValue andAverage:average];
                });
            }
                
            
        } else {
            [self showError:isConnectionError];
        }
    }];
    [self.webService downloadDataWithPath:@"/cota/media-maximo-desvio" andFinishBlock:^(NSArray *jsonArray, BOOL success, BOOL isConnectionError) {
        if(success) {
            NSNumber * numQuota;
            NSDecimalNumber * maxValue;
            NSDecimalNumber * average;
            double stdDeviation;
            
            
            for(NSDictionary *jsonDict in jsonArray) {
                
                NSString *maxString = [NSString stringWithFormat:@"%.2f",[jsonDict[@"valor_maximo"] doubleValue]];
                maxValue = [NSDecimalNumber decimalNumberWithString: maxString];
                // NSLog(@"valor maximo %@", maxValue);
                NSString *averageString = [NSString stringWithFormat:@"%.2f",[jsonDict[@"valor_medio"] doubleValue]];
                average = [NSDecimalNumber decimalNumberWithString: averageString];
                numQuota = jsonDict[@"numsubcota"];
                stdDeviation = [jsonDict[@"desvio_padrao"] doubleValue];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.statisticDao insertStatisticWithNumQuota:numQuota andMaxValue:maxValue andAverage:average andStdDeviation:stdDeviation ];
                });
            }
            
        } else {
            [self showError:isConnectionError];
        }
    }];
}


-(void) updateQuotasForParliamentary:(NSNumber*) idParliamentary {
    [self.webService downloadDataWithPath:[NSString stringWithFormat:@"/cota/parlamentar/%@", idParliamentary] andFinishBlock:^(NSArray *jsonArray, BOOL success, BOOL isConnectionError) {
        
        if(success) {
            static int numberOfFollowedParliamentariesQuotasUpdated = 0;
            NSNumber * idParliamentary;
            NSNumber * idQuota;
            NSNumber * numQuota;
            NSString *nameQuota;
            NSDecimalNumber * value;
            NSNumber * updateVersion;
            NSNumber * year;
            NSNumber * month;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            // Check for quota updateVersion
            
            NSDictionary *recoveredfollowedParliamentaryIdsAndUpdatesVersion = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getTemporaryFilePath]];
            
            for(NSDictionary *jsonDict in jsonArray) {
                idQuota = jsonDict[@"pk"];
                value = [NSDecimalNumber decimalNumberWithString:jsonDict[@"fields"][@"valor"]];
                idParliamentary = jsonDict[@"fields"][@"idparlamentar"];
                numQuota = jsonDict[@"fields"][@"numsubcota"];
                nameQuota = jsonDict[@"fields"][@"descricao"];
                month = jsonDict[@"fields"][@"mes"];
                year = jsonDict[@"fields"][@"ano"];
                updateVersion = jsonDict[@"fields"][@"versaoupdate"];

                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.quotaDao insertQuotaWithId:idQuota andNumQuota:numQuota andNameQuota:nameQuota andMonth:month andYear:year andIdUpdate:updateVersion andValue:value andIdParliamentary:idParliamentary];
                });
                
                NSNumber *oldUpdateVersion = recoveredfollowedParliamentaryIdsAndUpdatesVersion[idParliamentary][idQuota];
                if(oldUpdateVersion != nil && [updateVersion integerValue] > [oldUpdateVersion integerValue]) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        AKParliamentary *parliamentaryToBeNotified = [self.parliamentaryDao getParliamentaryWithId:idParliamentary];
                        if([self.parliamentaryToBeNotifiedArray containsObject:parliamentaryToBeNotified] == NO) {
                            [self.parliamentaryToBeNotifiedArray addObject:parliamentaryToBeNotified];
                            [self notifyParliamentaryUpdate:parliamentaryToBeNotified];
                            
                        }
                    });
                }
            }
            
            numberOfFollowedParliamentariesQuotasUpdated++;

            if(numberOfFollowedParliamentariesQuotasUpdated == [self.parliamentaryDao getAllFollowedPartliamentary].count && self.parliamentaryToBeNotifiedArray.count > 0) {
                NSMutableString *detailText = [[NSMutableString alloc] initWithString:@"Novos gastos para o(s) parlamentar(es):\n"];
                for(AKParliamentary *p in self.parliamentaryToBeNotifiedArray)
                    [detailText appendString:[NSString stringWithFormat:@"%@\n",p.nickName]];
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    self.hud.color = [AKUtil color1clear];
                    self.hud.detailsLabelFont = [UIFont boldSystemFontOfSize:12];
                    self.hud.detailsLabelColor = [AKUtil color4];
                    self.hud.detailsLabelText = detailText;
                    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seguidosdesativado"]];
                    self.hud.mode = MBProgressHUDModeCustomView;
                    
                    [self.hud show:YES];
                    [self.hud hide:YES afterDelay:4];
                    
                    self.hud = nil;
                });
            }
            
        } else {
            [self showError:isConnectionError];
        }
    }];
}

-(BOOL) isSearchBarHidden {
    return (self.tableView.contentOffset.y == -20 || self.tableView.contentOffset.y == -8);
}

-(void)transformNavigationBarButtons{
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        self.navigationItem.leftBarButtonItem.customView.transform
        = self.navigationItem.rightBarButtonItem.customView.transform
        = CGAffineTransformMakeScale(0.75, 0.75);
    } else {
        self.navigationItem.leftBarButtonItem.customView.transform
        = self.navigationItem.rightBarButtonItem.customView.transform
        = CGAffineTransformMakeScale(1, 1);
    }
}

-(void) filterParliamentary {
    NSArray *userDefinedStatesFilter = [self.settingsManager getStatesFilter];
    if(userDefinedStatesFilter.count > 0) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.uf IN %@", userDefinedStatesFilter];
        self.parliamentaryArray = [self.parliamentaryArray filteredArrayUsingPredicate:resultPredicate];
    }
    
    NSArray *userDefinedPartiesFilter = [self.settingsManager getPartiesFilter];
    if(userDefinedPartiesFilter.count > 0) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.party IN %@", userDefinedPartiesFilter];
        self.parliamentaryArray = [self.parliamentaryArray filteredArrayUsingPredicate:resultPredicate];
    }
    
    AKSettingsFilterQuotaOption quotaFilter = [self.settingsManager getQuotaFilter];
    if(quotaFilter != AKSettingsFilterQuotaOptionNone) {
        int quotaFilterValue = 0;
        switch(quotaFilter) {
            case AKSettingsFilterQuotaOption10:
                quotaFilterValue = 10000;
                break;
            case AKSettingsFilterQuotaOption30:
                quotaFilterValue = 30000;
                break;
            case AKSettingsFilterQuotaOption50:
                quotaFilterValue = 50000;
                break;
            case AKSettingsFilterQuotaOption100:
                quotaFilterValue = 100000;
                break;
            case AKSettingsFilterQuotaOption150:
                quotaFilterValue = 150000;
                break;
            case AKSettingsFilterQuotaOption200:
                quotaFilterValue = 200000;
                break;
            case AKSettingsFilterQuotaOption300:
                quotaFilterValue = 300000;
                break;
            default:
                break;
        }
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.valueRanking >= %lu", quotaFilterValue];
        self.parliamentaryArray = [self.parliamentaryArray filteredArrayUsingPredicate:resultPredicate];
    }
}

-(void) sortParliamentary {
    AKSettingsSortOption sortOption = [self.settingsManager getSortOption];
    
    NSComparator comparator = nil;
    
    switch (sortOption) {
        case AKSettingsSortOptionAlphabetic:
            comparator = ^NSComparisonResult(id a, id b) {
                AKParliamentary *first = (AKParliamentary*)a;
                AKParliamentary *second = (AKParliamentary*)b;
                return [first.nickName compare:second.nickName];
            };
            break;
        case AKSettingsSortOptionRanking:
            comparator = ^NSComparisonResult(id a, id b) {
                AKParliamentary *first = (AKParliamentary*)a;
                AKParliamentary *second = (AKParliamentary*)b;
                return [second.valueRanking compare:first.valueRanking];
            };
            
            break;
        case AKSettingsSortOptionState:
            comparator = ^NSComparisonResult(id a, id b) {
                AKParliamentary *first = (AKParliamentary*)a;
                AKParliamentary *second = (AKParliamentary*)b;
                return [first.uf compare:second.uf];
            };
            
            break;
        case AKSettingsSortOptionParty:
            comparator = ^NSComparisonResult(id a, id b) {
                AKParliamentary *first = (AKParliamentary*)a;
                AKParliamentary *second = (AKParliamentary*)b;
                return [first.party compare:second.party];
            };
            
            break;
        default:
            break;
    }
    
    self.parliamentaryArray = [self.parliamentaryArray sortedArrayUsingComparator:comparator];
}

-(void) showError:(BOOL) isConnectionError {
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIAlertView *alert = nil;
        
        if(isConnectionError)
            alert = [[UIAlertView alloc] initWithTitle:@":(" message:@"Não foi possível carregar os dados, verifique sua conexão com a internet." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        else
            alert = [[UIAlertView alloc] initWithTitle:@":(" message:@"Ocorreu algum erro com o nosso servidor, por conta disso o AKAN não conseguiu carregar novos dados. Abra o app mais tarde para tentar novamente." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    });
}

- (void)applyAllDefinedFiltersAndSort {
    
    if (self.viewFollowedEnabled) {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.followed == 1"];
        self.parliamentaryArray = [[self.parliamentaryDao getAllParliamentary] filteredArrayUsingPredicate:resultPredicate];
    } else {
        self.parliamentaryArray = [self.parliamentaryDao getAllParliamentary];
    }
    
    [self filterParliamentary];
    
    [self sortParliamentary];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        if([self.parliamentaryDao getAllParliamentary].count == 0) {
            self.toolBar.followedButton.enabled = NO;
            self.toolBar.searchButton.enabled = NO;
            self.toolBar.rankButton.enabled = NO;
        } else {
            self.toolBar.followedButton.enabled = YES;
            self.toolBar.searchButton.enabled = YES;
            self.toolBar.rankButton.enabled = YES;
        }
        
        if(self.parliamentaryArray.count == 0) {
            self.noResultsLabel.hidden = NO;
            self.tableView.hidden = YES;
            self.toolBar.rankButton.enabled = NO;
            self.toolBar.searchButton.enabled = NO;
        } else {
            self.noResultsLabel.hidden = YES;
            self.tableView.hidden = NO;
            self.toolBar.rankButton.enabled = YES;
            self.toolBar.searchButton.enabled = YES;
        }
    });
    
}

- (void)filterArrayByText:(NSString *)searchText {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.nickName contains[c] %@", searchText];
    self.parliamentaryNicknameFilteredArray = [self.parliamentaryArray filteredArrayUsingPredicate:resultPredicate];
}

-(void) notifyParliamentaryUpdate:(AKParliamentary*) parliamentary {
    //Add next local notification
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:@"O parlamentar %@ realizou novos gastos. Confira!", parliamentary.nickName];

    //Set the action button label (appears with the 'Close' button)
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    //Option add dictionary containing something you want when user selects action button and app is opened
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:parliamentary.idParliamentary
                                                         forKey:@"idParliamentary"];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

-(NSString *) getTemporaryFilePath {
    NSString *tempPath = NSTemporaryDirectory();

    return [NSString stringWithFormat:@"%@/akan_followed_temp.plist", tempPath];
}

@end
