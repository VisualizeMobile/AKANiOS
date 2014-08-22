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
#import "AKFilterOptionsView.h"
#import "AKFilterOptionsUpperTriangleView.h"
#import "AKParliamentaryDao.h"
#import "AKFilterOptionCollectionViewCell.h"

typedef NS_ENUM(short, AKConfigFilterCategory) {
    AKConfigFilterCategoryParty, AKConfigFilterCategoryQuota, AKConfigFilterCategoryState
};

@interface AKConfigViewController ()

@property(nonatomic) AKParliamentaryDao *partliamentaryDao;
@property(nonatomic) AKSettingsManager *settingsManager;
@property(nonatomic) AKFilterOptionsUpperTriangleView *filterUpperTriangleView;
@property(nonatomic) AKFilterOptionsView *filterView;
@property(nonatomic) UICollectionView *filterCollectionView;
@property(nonatomic) NSArray *filterViewOptionsArray;
@property(nonatomic) AKConfigFilterCategory filterCategory;

@property(nonatomic) BOOL makeFilterViewHideShowAnimation;

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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissFilterView:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    self.title = @"Configurações";
    self.makeFilterViewHideShowAnimation = YES;
    
    self.partliamentaryDao = [AKParliamentaryDao getInstance];
    
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
    
    // Configure filter collection view
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.filterCollectionView.delegate = self;
    self.filterCollectionView.dataSource = self;

    [self.filterCollectionView registerNib:[UINib nibWithNibName:@"AKFilterOptionCollectionViewCell" bundle:[NSBundle mainBundle]]  forCellWithReuseIdentifier:@"AKCell2"];

    self.filterCollectionView.backgroundColor = [AKUtil color4];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self transformNavigationBarButtons];
    
    UIInterfaceOrientation actualOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self arrangeSortButtons:actualOrientation];
    
    
    switch([self.settingsManager getSortOption]) {
        case AKSettingsSortOptionRanking:
            [self.rankingSortButton setSelected:YES];
            break;
        case AKSettingsSortOptionParty:
            [self.partySortButton setSelected:YES];
            break;

        case AKSettingsSortOptionAlphabetic:
            [self.alphabeticSortButton setSelected:YES];
            break;

        case AKSettingsSortOptionState:
            [self.stateSortButton setSelected:YES];
            break;
    }
}


-(void)viewDidLayoutSubviews {

}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self transformNavigationBarButtons];
    
    self.makeFilterViewHideShowAnimation = NO;
    UIInterfaceOrientation actualOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(self.filterView.superview != nil && actualOrientation != fromInterfaceOrientation) {
        switch (self.filterCategory) {
            case AKConfigFilterCategoryParty:
                [self addFilterView:self.partyFilterButton];
                break;
            case AKConfigFilterCategoryQuota:
                [self addFilterView:self.quotaFilterButton];
                break;
            case AKConfigFilterCategoryState:
                [self addFilterView:self.stateFilterButton];
                break;
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self arrangeSortButtons:toInterfaceOrientation];
}

#pragma mark - Gesture recognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != self.view) // accept only touchs on superview, not accept touchs on subviews
        return NO;
    else
        return YES;
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

- (void)addFilterView:(UIButton*) filterButton {
    if(self.filterView != nil)
        [self removeFilterView];
    
    self.filterUpperTriangleView = [[AKFilterOptionsUpperTriangleView alloc] initWithFrame: CGRectMake(10, self.partyFilterLabel.frame.origin.y+self.partyFilterLabel.frame.size.height + 3, self.view.frame.size.width-20, 10) andFilterIconXAxysCenter:filterButton.center.x];
    
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float filterViewHeight = 0;
    int collectionViewNumberOfLines = 0;
    
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        collectionViewNumberOfLines = ceilf((float) self.filterViewOptionsArray.count / 4);

        // Min number of lines
        if(collectionViewNumberOfLines < 3)
            collectionViewNumberOfLines = 3;
        
    } else if(UIInterfaceOrientationIsLandscape(orientation)) {
        collectionViewNumberOfLines = ceilf((float) self.filterViewOptionsArray.count / 7);

        // Min number of lines
        if(collectionViewNumberOfLines < 2)
            collectionViewNumberOfLines = 2;
    }

    // top padding filter view to collection = 10
    // cell height + margin bottom to cell = 25 + 10
    // the last margin bottom to cell acts like a padding filter view to collection (10)
    filterViewHeight = 10 + (collectionViewNumberOfLines * (25+10));
    
    self.filterView = [[AKFilterOptionsView alloc] initWithFrame:
                       CGRectMake(10, self.filterUpperTriangleView.frame.origin.y+self.filterUpperTriangleView.frame.size.height, self.view.frame.size.width-20, filterViewHeight)];
    
    self.filterCollectionView.frame = CGRectMake(5, 10, self.filterView.frame.size.width-10, self.filterView.frame.size.height-10);
    
    [self.filterCollectionView reloadData];
    
    [self.filterView addSubview:self.filterCollectionView];
    
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.filterUpperTriangleView];
    
    
    if(self.makeFilterViewHideShowAnimation) {
        self.filterView.alpha = self.filterUpperTriangleView.alpha = 0;
        
        [UIView animateWithDuration:0.1f delay:0.1f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.filterView.alpha = self.filterUpperTriangleView.alpha = 1;
        } completion:nil];
    }
    
    [self.view addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:[filterUpperTriangleView]-0-[filterView(height)]-(20)-|"
                                     options:0
                                     metrics:@{@"height" : [NSNumber numberWithFloat:self.filterView.frame.size.height]}
                                     views:@{@"filterView" : self.filterView,
                                             @"filterUpperTriangleView" : self.filterUpperTriangleView}]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-10-[filterView(width)]"
                               options:0
                               metrics:@{@"width" : [NSNumber numberWithFloat:self.dividerView.frame.size.width]}
                               views:@{@"filterView" : self.filterView}]];
    
    if(self.makeFilterViewHideShowAnimation == YES && self.scrollView.contentSize.height > self.scrollView.bounds.size.height) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int)(0.2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
            [self.scrollView setContentOffset:bottomOffset animated:YES];
        });
    }
    
    self.makeFilterViewHideShowAnimation = YES;
}

-(void) removeFilterView {
    // This is to made to don't work directly with the properties, because they will point to another objects in the "completion:" block
    AKFilterOptionsUpperTriangleView *filterUpperTriangleViewOld = self.filterUpperTriangleView;
    AKFilterOptionsView *filterViewOld = self.filterView;
    
    if(self.makeFilterViewHideShowAnimation) {
        filterViewOld.alpha = filterUpperTriangleViewOld.alpha = 1;
        
        [UIView animateWithDuration:0.1f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
            filterViewOld.alpha = filterUpperTriangleViewOld.alpha = 0;
        } completion:^ (BOOL finished) {
            [filterViewOld removeFromSuperview];
            [filterUpperTriangleViewOld removeFromSuperview];
        }];
    } else {
        [filterViewOld removeFromSuperview];
        [filterUpperTriangleViewOld removeFromSuperview];
    }
}

#pragma mark - Collection view data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filterViewOptionsArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AKCell2";
    AKFilterOptionCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(self.filterCategory == AKConfigFilterCategoryParty) {
        NSArray *userDefinedParties = [self.settingsManager getPartiesFilter];
        if([userDefinedParties containsObject:self.filterViewOptionsArray[indexPath.row]]) {
            cell.backgroundColor = [AKUtil color5];
        }
    } else if(self.filterCategory == AKConfigFilterCategoryState) {
        NSArray *userDefinedStates = [self.settingsManager getStatesFilter];
        if([userDefinedStates containsObject:self.filterViewOptionsArray[indexPath.row]]) {
            cell.backgroundColor = [AKUtil color5];
        }
    } else if (self.filterCategory == AKConfigFilterCategoryQuota) {
        if (indexPath.row == (int)[self.settingsManager getQuotaFilter]) {
            cell.backgroundColor = [AKUtil color5];
        }
    }
    
    cell.textLabel.text = self.filterViewOptionsArray[indexPath.row];
    
    return cell;
}

#pragma mark - Collection view delegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 25);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.filterCategory == AKConfigFilterCategoryQuota) {
        NSIndexPath *toBeDeselectedIndex = [NSIndexPath indexPathForItem:(int)[self.settingsManager getQuotaFilter] inSection:0];
        
        [self.filterCollectionView cellForItemAtIndexPath:toBeDeselectedIndex].backgroundColor = [AKUtil color1];
        
        [self.filterCollectionView cellForItemAtIndexPath:indexPath].backgroundColor = [AKUtil color5];
        [self.settingsManager setQuotaFilterOption:(AKSettingsFilterQuotaOption)indexPath.row];

    } else if(self.filterCategory == AKConfigFilterCategoryParty) {
        if([[self.settingsManager getPartiesFilter] containsObject: self.filterViewOptionsArray[indexPath.row]]) {
            [self.filterCollectionView cellForItemAtIndexPath:indexPath].backgroundColor = [AKUtil color1];
            
            [self.settingsManager removePartyFilter:self.filterViewOptionsArray[indexPath.row]];
        } else { // New filter
            [self.filterCollectionView cellForItemAtIndexPath:indexPath].backgroundColor = [AKUtil color5];
            
            [self.settingsManager addPartyFilter:self.filterViewOptionsArray[indexPath.row]];
        }
        
    } else if(self.filterCategory == AKConfigFilterCategoryState) {
        if([[self.settingsManager getStatesFilter] containsObject: self.filterViewOptionsArray[indexPath.row]]) {
            [self.filterCollectionView cellForItemAtIndexPath:indexPath].backgroundColor = [AKUtil color1];
            
            [self.settingsManager removeStateFilter:self.filterViewOptionsArray[indexPath.row]];
        } else { // New filter
            [self.filterCollectionView cellForItemAtIndexPath:indexPath].backgroundColor = [AKUtil color5];
            
            [self.settingsManager addStateFilter:self.filterViewOptionsArray[indexPath.row]];
        }
    }

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

- (IBAction)filterParty:(id)sender {
    self.filterCategory = AKConfigFilterCategoryParty;
    self.filterViewOptionsArray = [self.partliamentaryDao getAllParliamentaryParties];
    
    [self addFilterView:self.partyFilterButton];
}
- (IBAction)filterQuota:(id)sender {
    self.filterCategory = AKConfigFilterCategoryQuota;
    self.filterViewOptionsArray = @[@"+ 0",  @"+ 10.000", @"+ 30.000", @"+ 50.000", @"+ 80.000"];
    
    [self addFilterView:self.quotaFilterButton];
}
- (IBAction)filterState:(id)sender {
    self.filterCategory = AKConfigFilterCategoryState;
    self.filterViewOptionsArray = [self.partliamentaryDao getAllParliamentaryStates];
    
    [self addFilterView:self.stateFilterButton];
}

-(void)dismissFilterView:(id) sender {
    [self removeFilterView];
}

@end
