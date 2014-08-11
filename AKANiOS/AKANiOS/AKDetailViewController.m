//
//  AKDetailViewController.m
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import "AKDetailViewController.h"
#import "AKQuotaCollectionViewCell.h"
#import "AKEmptyQuotaCollectionViewCell.h"
#import "AKQuotaDao.h"
#import "AKQuota.h"

@interface AKDetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *quotaCollectionView;
@property (nonatomic) AKQuotaDao *quotaDao;
@property (nonatomic) NSArray *quotas;

@end

@implementation AKDetailViewController

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
    
    self.quotaDao = [AKQuotaDao getInstance];
    self.quotas = [self.quotaDao getQuotas];
    
    //registering cell nib that is required for collectionView te dequeue it.
    [self.quotaCollectionView registerNib:[UINib nibWithNibName:@"AKQuotaCollectionViewCell" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"AKCell"];
    
    [self.quotaCollectionView registerNib:[UINib nibWithNibName:@"AKEmptyQuotaCollectionViewCell" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"AKEmptyCell"];
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"backImage"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = [self.parliamentary firstName];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView DataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.quotas count];
}

#pragma mark - CollectionView Delegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"AKCell";
    static NSString *emptyCellIdentifier = @"AKEmptyCell";
    
    AKQuota *quota = self.quotas[indexPath.row];
    if (quota.isEmpty) {
        AKEmptyQuotaCollectionViewCell *cell = (AKEmptyQuotaCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:emptyCellIdentifier forIndexPath:indexPath];
        cell.quota = quota;
        [cell imageForQuotaValue];
        return cell;
    }
    else{
        AKQuotaCollectionViewCell *cell = (AKQuotaCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.quota = quota;
        [cell imageForQuotaValue];
        return cell;
    }

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selecionou");
}

#pragma mark - Custom Methods

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
