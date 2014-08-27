//
//  AKQuotaCollectionViewCell.h
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 07/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKQuota.h"

@interface AKQuotaCollectionViewCell : UICollectionViewCell

@property (nonatomic)AKQuota *quota;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
 
-(void)imageForQuotaValue;
@end
