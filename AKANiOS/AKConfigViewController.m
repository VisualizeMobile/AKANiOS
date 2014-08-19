//
//  AKConfigViewController.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 13/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKConfigViewController.h"
#import "AKUtil.h"
#import "AKSettingsManager.h"

@interface AKConfigViewController ()

@property(nonatomic) AKSettingsManager *settingsManager;

@end

@implementation AKConfigViewController

#pragma mark - View controller methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure initial data
    self.settingsManager = [AKSettingsManager sharedManager];
    
    // Configure sort buttons
    [self.partySortButton setImage:[UIImage imageNamed:@"partidoativado"] forState:UIControlStateSelected];
    [self.rankingSortButton setImage:[UIImage imageNamed:@"rankingativado"] forState:UIControlStateSelected];
    [self.alphabeticSortButton setImage:[UIImage imageNamed:@"alfabetoativado"] forState:UIControlStateSelected];
    [self.stateSortButton setImage:[UIImage imageNamed:@"estadoativado"] forState:UIControlStateSelected];
    
    // Configure dismiss button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = dismissButton;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self transformNavigationBarButtons];
    
    UIInterfaceOrientation actualOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self arrangeSortButtons:actualOrientation];
}


-(void)viewDidLayoutSubviews {

}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self transformNavigationBarButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self arrangeSortButtons:toInterfaceOrientation];
}

#pragma mark - custom methods

- (IBAction)dismissViewController:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)transformNavigationBarButtons {
    
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

- (void)arrangeSortButtons:(UIInterfaceOrientation)toOrientation {
    if(UIInterfaceOrientationIsLandscape(toOrientation)) {
        self.alphabeticSortIconLeftMarginConstraint.constant = 31+96;
        self.alphabeticSortLabelLeftMarginConstraint.constant = 24+96;
        self.rankingSortIconLeftMarginConstraint.constant = 24+83;
        self.rankingSortLabelLeftMarginConstraint.constant = 23+83;
    } else if(UIInterfaceOrientationIsPortrait(toOrientation)) {
        self.alphabeticSortIconLeftMarginConstraint.constant = 31;
        self.alphabeticSortLabelLeftMarginConstraint.constant = 24;
        self.rankingSortIconLeftMarginConstraint.constant = 24;
        self.rankingSortLabelLeftMarginConstraint.constant = 23;
    }
    
    [self.view layoutSubviews];
}

-(void) clearSortButtons {
    self.partySortButton.selected = self.rankingSortButton.selected = self.alphabeticSortButton.selected = self.stateSortButton.selected = NO;
}

#pragma mark - Action methods

- (IBAction)sortByPaty:(id)sender {
    [self clearSortButtons];
    [self.partySortButton setSelected:!self.partySortButton.selected];
    
    [self.settingsManager setSortOption:AKSettingsSortOptionParty];
}
- (IBAction)sortByRanking:(id)sender {
    [self clearSortButtons];
    [self.rankingSortButton setSelected:!self.rankingSortButton.selected];
    
    [self.settingsManager setSortOption:AKSettingsSortOptionRanking];
}
- (IBAction)sortByName:(id)sender {
    [self clearSortButtons];
    [self.alphabeticSortButton setSelected:!self.alphabeticSortButton.selected];
    
    [self.settingsManager setSortOption:AKSettingsSortOptionAlphabetic];
}
- (IBAction)sortByState:(id)sender {
    [self clearSortButtons];
    [self.stateSortButton setSelected:!self.stateSortButton.selected];
    
    [self.settingsManager setSortOption:AKSettingsSortOptionState];
}

@end
