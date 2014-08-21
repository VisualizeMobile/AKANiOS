//
//  AKDetailViewController.h
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKParliamentary.h"

@interface AKDetailViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic) AKParliamentary *parliamentary;
@property (weak, nonatomic) IBOutlet UILabel *rankPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *parliamentaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;
@property (weak, nonatomic) IBOutlet UILabel *ufLabel;
@property (weak, nonatomic) IBOutlet UITextField *datePickerField;

@end
