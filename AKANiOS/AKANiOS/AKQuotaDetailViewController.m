//
//  AKQuotaDetailViewController.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 22/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKQuotaDetailViewController.h"
#import "AKStatisticDao.h"
#import "AKQuotaDao.h"
#import "AKUtil.h"
#import "CorePlotHeaders/CorePlot-CocoaTouch.h"
#import <Social/Social.h>
#import "UIView+ImageFromView.h"

@interface AKQuotaDetailViewController ()

@property(nonatomic) NSArray *quotasArray;
@property(nonatomic) NSArray *middleQuotasArray;
@property(nonatomic) CPTTheme *currentTheme;
@property(nonatomic) AKStatisticDao *statisticDao;
@property(nonatomic) AKQuotaDao *quotaDao;
@end

@implementation AKQuotaDetailViewController

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
    UIImage *backButtonImage = [UIImage imageNamed:@"backImage"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.title = self.quota.nameQuota;
    
    self.statisticDao = [AKStatisticDao getInstance];
    self.quotaDao = [AKQuotaDao getInstance];
    self.quotasArray = [self.quotaDao getQuotasByIdParliamentary:self.parliamentary.idParliamentary withNumQuota:self.quota.numQuota andYear:self.quota.year];
    self.middleQuotasArray = [self.statisticDao getStatisticByYear:self.quota.year andNumQuota: self.quota.numQuota];
    
    [self setDetailItem];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareFacebook:)];
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

-(void) shareFacebook: (id) sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *composeController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
        numberFormatter.minimumFractionDigits = 2;
        NSString *formattedNumberString = [numberFormatter stringFromNumber:self.parliamentary.valueRanking];

        CGRect viewToScreenshotFrame = self.hostingView.frame;
        viewToScreenshotFrame.size.width += 70;
        self.hostingView.frame = viewToScreenshotFrame;
        
        UIImageView *parliamentaryPhotoView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:self.parliamentary.photoParliamentary]];

        CGRect photoViewFrame = parliamentaryPhotoView.frame;
        photoViewFrame.size.width = 80;
        photoViewFrame.size.height = 80;
        photoViewFrame.origin.x = self.hostingView.frame.size.width - photoViewFrame.size.width;
        photoViewFrame.origin.y = 20;
        parliamentaryPhotoView.frame = photoViewFrame;
        
        parliamentaryPhotoView.layer.cornerRadius = parliamentaryPhotoView.frame.size.height /2;
        parliamentaryPhotoView.layer.masksToBounds = YES;
        parliamentaryPhotoView.layer.borderWidth = 1.5;
        parliamentaryPhotoView.layer.borderColor = [UIColor blackColor].CGColor;
        
        [self.hostingView addSubview:parliamentaryPhotoView];
        
        NSString *text = [NSString stringWithFormat:@"Estes são os gastos com %@ do deputado %@ do %@/%@. Apenas este ano já foram gastos um total R$ %@ por ele. Fonte = http://www2.camara.leg.br/transparencia/dados-abertos.\nBaixe já o aplicativo AKAN para saber os gastos dos nossos deputados federais!", self.quota.nameQuota, self.parliamentary.nickName, self.parliamentary.party, self.parliamentary.uf, formattedNumberString];
        
        [composeController setInitialText:text];
        [composeController addImage:[UIView imageWithView:self.hostingView]];
        [composeController addURL: [NSURL URLWithString:@"http://google.com/"]];
        
        [parliamentaryPhotoView removeFromSuperview];
        viewToScreenshotFrame.size.width -= 70;
        self.hostingView.frame = viewToScreenshotFrame;
        
        [self presentViewController:composeController animated:YES completion:nil];
        
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"delete");
            } else {
                NSLog(@"post");
            }
        };
        composeController.completionHandler =myBlock;
    } else {
        UIAlertView *alertNotPossible = [[UIAlertView alloc] initWithTitle:@":(" message:@"Não foi possível compartilhar no Facebook." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertNotPossible show];
    }
}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setDetailItem
{
    AKCurvedScatterPlot *newDetailItem = [[AKCurvedScatterPlot alloc] init];
    self.detailItem = newDetailItem;
    self.detailItem.year = [self.quota.year stringValue];
    self.detailItem.title = self.quota.nameQuota;
    NSString *name = self.parliamentary.nickName;
    NSString *kName;
    
    if ([name length] >=23) {
        kName = [name substringToIndex:20];
        self.detailItem.kData = [NSString stringWithFormat:@"Gastos de %@...", kName];
    }
    else{
        self.detailItem.kData = [NSString stringWithFormat:@"Gastos de %@", name];
    }
    self.detailItem.quotas = self.quotasArray;
    self.detailItem.middleQuotas = self.middleQuotasArray;
    self.currentTheme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [self.detailItem renderInView:self.hostingView withTheme:self.currentTheme animated:YES];
}

-(void) dealloc{
    self.hostingView = nil;
    self.detailItem = nil;
}
@end
