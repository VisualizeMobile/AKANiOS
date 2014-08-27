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
    
    AKQuotaDao *dao = [AKQuotaDao getInstance];
    self.quotasArray = [dao getQuotasByIdParliamentary:self.parliamentary.idParliamentary withNumQuota:self.quota.numQuota];
    NSLog(@"%@",self.quotasArray);
    
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
    self.hostingView.frame = self.view.bounds;
    [self.detailItem renderInView:self.hostingView withTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme] animated:YES];
}


#pragma mark - Custom methods

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setDetailItem
{
    AKCurvedScatterPlot *newDetailItem = [[AKCurvedScatterPlot alloc] init];
    self.detailItem = newDetailItem;
    [self.detailItem renderInView:self.hostingView withTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme] animated:YES];
}

-(void) dealloc{
    self.hostingView = nil;
    self.detailItem = nil;
}
@end
