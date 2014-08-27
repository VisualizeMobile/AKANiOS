//
//  AKQuotaDetailViewController.h
//  AKANiOS
//
//  Created by Matheus Fonseca on 22/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKQuota.h"
#import "AKParliamentary.h"
#import "CorePlot-CocoaTouch.h"
#import "AKCurvedScatterPlot.h"

@interface AKQuotaDetailViewController : UIViewController
   
@property (nonatomic, strong) AKCurvedScatterPlot *detailItem;
@property (nonatomic, strong) IBOutlet UIView *hostingView;

@property(nonatomic) AKParliamentary *parliamentary;
@property(nonatomic) AKQuota *quota;

@end
