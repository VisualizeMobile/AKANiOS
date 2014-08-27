//
//  AKQuotaDetailViewController.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 22/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKQuotaDetailViewController.h"
#import "AKQuotaDao.h"
#import "AKUtil.h"
#import "CorePlotHeaders/CorePlot-CocoaTouch.h"

@interface AKQuotaDetailViewController ()

@property(nonatomic) NSArray *quotasArray;
@property(nonatomic) NSArray *middleQuotasArray;
@property(nonatomic) CPTTheme *currentTheme;
@property(nonatomic) AKQuotaDao *quotaDao;
@end

@implementation AKQuotaDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //[self setDetailItem];
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
    
    self.quotaDao = [AKQuotaDao getInstance];
    self.quotasArray = [self.quotaDao getQuotasByIdParliamentary:self.parliamentary.idParliamentary withNumQuota:self.quota.numQuota];
    self.middleQuotasArray = [self.quotaDao getQuotasByIdParliamentary: [NSNumber numberWithInt:-1] withNumQuota:self.quota.numQuota];
    [self setDetailItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGRect frame = self.view.bounds;
    frame.size.height -= 60;
    frame.origin.y += 62;
    self.hostingView.frame = frame;
    [self.detailItem renderInView:self.hostingView withTheme:self.currentTheme animated:YES];
}


#pragma mark - Custom methods

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setDetailItem
{
    AKCurvedScatterPlot *newDetailItem = [[AKCurvedScatterPlot alloc] init];
    self.detailItem = newDetailItem;
    self.detailItem.quotas = self.quotasArray;
    self.detailItem.middlQquotas = [self.quotaDao getMiddleQuotasWithQuotaNumber:self.quota.numQuota andYear:self.quota.year];
    self.currentTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [self.detailItem renderInView:self.hostingView withTheme:self.currentTheme animated:YES];
}

-(void) dealloc{
    self.hostingView = nil;
    self.detailItem = nil;
}
@end
