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

@interface AKQuotaDetailViewController : UIViewController <CPTPlotDataSource, UIActionSheetDelegate>


@property(nonatomic) AKParliamentary *parliamentary;
@property(nonatomic) NSString *quotaName;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
