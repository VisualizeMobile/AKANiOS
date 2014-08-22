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
#import "Parliamentary.h"
#import "AKSettingsManager.h"
#import "AKConfigViewController.h"

#import "AKQuotaDao.h"
#import "Quota.h"
#import "AKLoad.h"

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
@property (nonatomic) AKSettingsManager *settingsManager;

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

    self.settingsManager = [AKSettingsManager sharedManager];
    NSLog(@"Configuração atual do App = \n%@", [self.settingsManager actualSettingsInfoLog]);
    
    self.lastOrientationWasLadscape = NO;
    self.autolayoutCameFromSearchDismiss = NO;
    self.needsToHideSearchBar = YES;
    
    // Experimental datas
    AKLoad *experimental=[[AKLoad alloc]init];
    [experimental loadParliamentariesTestData];
    [experimental loadQuotasTestData];
    
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
    self.parliamentaryArray = [self.parliamentaryDao getAllParliamentary];
    self.parliamentaryNicknameFilteredArray = [NSArray array];
    
    [self filterParliamentary];
    
    [self sortParliamentary];
    
    [self transformNavigationBarButtons];
    
    [self.tableView reloadData];
    
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
    
    [UIView animateWithDuration:0.4
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
    NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc] init];
    NSString *formattedNumberString;
    
    AKMainTableViewCell *cell = (AKMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AKMainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.quotaSum.hidden = cell.rankPosition.hidden = !self.viewByRankEnabled;
    
    AKParliamentary *parliamentary = nil;
    
    if (tableView == self.searchController.searchResultsTableView)
    {
        parliamentary = self.parliamentaryNicknameFilteredArray[indexPath.row];
    } else {
        parliamentary = self.parliamentaryArray[indexPath.row];
    }
    
    cell.parliamentaryName.text = parliamentary.nickName;
    cell.parliamentaryPhoto.image=[UIImage imageWithData:parliamentary.photoParliamentary];
    cell.partyLabel.text=parliamentary.party;
    cell.ufLabel.text=parliamentary.uf;
    cell.rankPosition.text=[NSString stringWithFormat:@"%@º", parliamentary.posRanking];
    
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    formattedNumberString=[numberFormatter stringFromNumber:parliamentary.valueRanking];
    cell.quotaSum.text=[NSString stringWithFormat:@"R$ %@",formattedNumberString];
    
    [cell.followedButton addTarget:self action:@selector(followParliementary:) forControlEvents:UIControlEventTouchUpInside];
    

    return cell;
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
            NSLog(@"Parlamentar %@",parliamentary.nickName);
        } else {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            parliamentary = self.parliamentaryArray[indexPath.row];
            NSLog(@"Parlamentar %@",parliamentary.nickName);
        }
    }
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
    {
        detailController.parliamentary = [self.parliamentaryArray objectAtIndex:indexPath.row];
        
    }
    [self.navigationController pushViewController:detailController animated:YES];
    
}

#pragma mark - Search Bar Delegate

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.nickName contains[c] %@", searchText];
    self.parliamentaryNicknameFilteredArray = [self.parliamentaryArray filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString
                               scope:[[self.searchController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    self.searchController.searchResultsTableView.delegate = self;
}

-(void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    self.searchEnabled = NO;
    [self.toolBar.searchButton setSelected:self.searchEnabled];
    
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

#pragma mark - Actions

-(void) searchByName:(id) sender {
    self.searchEnabled = !self.searchEnabled;
    [self.toolBar.searchButton setSelected:self.searchEnabled];

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


-(void) viewByRank:(id) sender {
    self.viewByRankEnabled = !self.viewByRankEnabled;
    [self.toolBar.rankButton setSelected:self.viewByRankEnabled];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

-(void) viewFollowed:(id) sender {
     self.viewFollowedEnabled = !self.viewFollowedEnabled;
    [self.toolBar.followedButton setSelected:self.viewFollowedEnabled];

}

-(void) configuration:(id) sender {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[AKConfigViewController alloc] init]];
    nav.navigationBar.barTintColor = [AKUtil color1];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [AKUtil color4]};
    nav.navigationBar.tintColor = [AKUtil color4];

    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
    //Teste do Ramon
    AKLoad *load=[[AKLoad alloc]init];
    [load loadQuotasTestData];
}

-(void) infoScreen:(id) sender {
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[AKInfoViewController alloc] init]];
    
    nav.navigationBar.barTintColor = [AKUtil color1];
    nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [AKUtil color4]};
    nav.navigationBar.tintColor = [AKUtil color4];

    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
    //Testes Ramon
    AKQuotaDao *quotaDAo=[AKQuotaDao getInstance];
    [quotaDAo deleteQuotaByIdParliamentary:@"141467"];
}

#pragma mark - Custom methods
       
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
            case AKSettingsFilterQuotaOption80:
                quotaFilterValue = 80000;
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


@end
