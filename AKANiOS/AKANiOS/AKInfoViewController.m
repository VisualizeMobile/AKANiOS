//
//  AKInfoViewController.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKInfoViewController.h"
#import "AKUtil.h"

@interface AKInfoViewController ()
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastLabel;


@end

@implementation AKInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [button setBackgroundImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismissViewController:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        dismissButton.tintColor = [AKUtil color4];
        self.navigationItem.rightBarButtonItem = dismissButton;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"AKAN";
    self.scrollViewInfo.delegate=self;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self transformNavigationBarButtons];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.infoLabel sizeToFit];
    self.infoLabel.preferredMaxLayoutWidth=self.infoLabel.frame.size.width;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollViewInfo.contentSize= CGSizeMake(self.view.frame.size.width,(self.lastLabel.frame.origin.y+self.lastLabel.frame.size.height));
    
}


-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self transformNavigationBarButtons];
    
    [self.infoLabel sizeToFit];
    self.infoLabel.preferredMaxLayoutWidth=self.infoLabel.frame.size.width;
}

#pragma mark - custom methods

- (IBAction)dismissViewController:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)transformNavigationBarButtons{
    
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

@end
