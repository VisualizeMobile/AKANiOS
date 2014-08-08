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
#import "AKParliamentaryDao.h"
#import "AKToolBar.h"
#import "AKUtil.h"

@interface AKMainListViewController ()
@property (nonatomic) AKParliamentaryDao *parliamentaryDao;
@end

@implementation AKMainListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Parlamentares";
    
    self.parliamentaryDao = [AKParliamentaryDao getInstance];
    self.parliamentaryArray = [self.parliamentaryDao getAllParliamentary];
    
    // Configure toolbar
    AKToolBar *toolBar = [[AKToolBar alloc] initWithFrame:CGRectZero];
    [toolBar.followedButton addTarget:self action:@selector(viewFollowed:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar.rankButton addTarget:self action:@selector(viewByRank:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar.searchButton addTarget:self action:@selector(searchByName:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.toolBarContainer addSubview: toolBar];
    self.toolBarContainer.backgroundColor = [AKUtil color3];
    
//    NSDictionary *views = @{ @"toolBar" : toolBar,
//                             @"toolBarContainer" : self.toolBarContainer};
//    
//    [self.toolBarContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(==0)-[toolBar]-0-|"
// options:0 metrics:nil views:views]];
//    [self.toolBarContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[toolBar]-0-|"
//                                                                      options:0 metrics:nil views:views]];


    // Configure navigation bar
    UIButton* configButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    [configButton setBackgroundImage:[UIImage imageNamed:@"configuracao"] forState:UIControlStateNormal];
    [configButton addTarget:self action:@selector(configuration:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:configButton];
    
    UIButton* infoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 43, 43)];
    [infoButton setBackgroundImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoScreen:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.parliamentaryArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    AKMainTableViewCell *cell = (AKMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AKMainTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    AKDetailViewController *detailController = [[AKDetailViewController alloc] init];
    detailController.parliamentary = [self.parliamentaryArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailController animated:YES];
    
}

#pragma mark - Custom methods

#pragma mark - Actions

-(void) searchByName:(id) sender {
    NSLog(@"%s", __FUNCTION__);
}


-(void) viewByRank:(id) sender {
    NSLog(@"%s", __FUNCTION__);
}

-(void) viewFollowed:(id) sender {
    NSLog(@"%s", __FUNCTION__);
}

-(void) configuration:(id) sender {
    NSLog(@"%s", __FUNCTION__);
}

-(void) infoScreen:(id) sender {
    NSLog(@"%s", __FUNCTION__);
}

@end
