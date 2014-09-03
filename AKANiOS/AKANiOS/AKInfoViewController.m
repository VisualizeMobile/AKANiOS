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

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.scrollViewInfo.contentSize = CGSizeMake(320,3200);
    
    for(UIView *view in self.scrollViewInfo.subviews) {
        if([view isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView*) view;
            
            [textView sizeToFit];
            [textView.textContainer setSize:textView.frame.size];
        }
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self transformNavigationBarButtons];
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
