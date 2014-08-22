//
//  AKQuotaDetailViewController.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 22/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKQuotaDetailViewController.h"
#import "AKQuotaDao.h"
@interface AKQuotaDetailViewController ()

@property(nonatomic) NSArray *quotasArray;

@end

@implementation AKQuotaDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *backButtonImage = [UIImage imageNamed:@"backImage"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = self.quota.nameQuota;
    
    AKQuotaDao *dao = [AKQuotaDao getInstance];
    self.quotasArray = [dao getQuotasByIdParliamentary:self.quota.idParliamentary withName:self.quota.nameQuota];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
