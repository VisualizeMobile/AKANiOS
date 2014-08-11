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

@interface AKMainListViewController ()

@property (nonatomic) UISearchDisplayController *searchController;
@property (nonatomic) NSArray *parliamentaryArray;
@property (nonatomic) NSArray *parliamentaryFilteredArray;
@property (nonatomic) BOOL viewByRankEnabled;
@property (nonatomic) BOOL viewFollowedEnabled;
@property (nonatomic) BOOL searchEnabled;
@property (nonatomic) AKToolBar *toolBar;
@property (nonatomic) AKParliamentaryDao *parliamentaryDao;

@property (nonatomic) BOOL lastOrientationWasLadscape;
@property (nonatomic) BOOL autolayoutCameFromSearchDismiss;
@property (nonatomic) BOOL needsToHideSearchBar;

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
    self.parliamentaryDao = [AKParliamentaryDao getInstance];
    self.parliamentaryArray = [self.parliamentaryDao getAllParliamentary];
    self.parliamentaryFilteredArray = [NSArray array];
    
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

-(BOOL)shouldAutorotateToInterfaceOrientation {
    return NO;
}

-(void)viewWillLayoutSubviews {
    self.needsToHideSearchBar = [self isSearchBarHidden];
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

    if(UIInterfaceOrientationIsLandscape(orientation))
        self.lastOrientationWasLadscape = YES;
    else
        self.lastOrientationWasLadscape = NO;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        // TODO
    }
}
#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchController.searchResultsTableView)
        return self.parliamentaryFilteredArray.count;
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
    
    AKParliamentary *parliamentary = nil;
    if (tableView == self.searchController.searchResultsTableView) {
        parliamentary = self.parliamentaryFilteredArray[indexPath.row];
    } else {
        parliamentary = self.parliamentaryArray[indexPath.row];
    }
    
    cell.parliamentaryName.text = parliamentary.name;
    
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
        detailController.parliamentary = [self.parliamentaryFilteredArray objectAtIndex:indexPath.row];
    else
        detailController.parliamentary = [self.parliamentaryArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailController animated:YES];
    
}

#pragma mark - Search Bar Delegate

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    self.parliamentaryFilteredArray = [self.parliamentaryArray filteredArrayUsingPredicate:resultPredicate];
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
}

#pragma mark - Actions

-(void) searchByName:(id) sender {
    self.searchEnabled = !self.searchEnabled;
    [self.toolBar.searchButton setSelected:self.searchEnabled];
    
    
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

}

-(void) infoScreen:(id) sender {
    [self.navigationController presentViewController:[[AKInfoViewController alloc] init] animated:YES completion:nil];
}

#pragma mark - Custom methods
       
-(BOOL) isSearchBarHidden {
    return (self.tableView.contentOffset.y == -20 || self.tableView.contentOffset.y == -8);
}

@end