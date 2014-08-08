//
//  AKDetailViewController.m
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import "AKDetailViewController.h"
#import "AKQuotaCollectionViewCell.h"

@interface AKDetailViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *quotaCollectionView;

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
    //registering cell nib that is required for collectionView te dequeue it.
    [self.quotaCollectionView registerNib:[UINib nibWithNibName:@"AKQuotaCollectionViewCell" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"AKCell"];
    
    self.navigationItem.title = [self.parliamentary firstName];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 13;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"AKCell";
    AKQuotaCollectionViewCell *cell = (AKQuotaCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}
@end
