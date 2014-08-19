//
//  AKConfigViewController.h
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 13/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKConfigViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alphabeticSortIconLeftMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankingSortIconLeftMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rankingSortLabelLeftMarginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alphabeticSortLabelLeftMarginConstraint;
@property (weak, nonatomic) IBOutlet UIButton *partySortButton;
@property (weak, nonatomic) IBOutlet UIButton *rankingSortButton;
@property (weak, nonatomic) IBOutlet UIButton *alphabeticSortButton;
@property (weak, nonatomic) IBOutlet UIButton *stateSortButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
