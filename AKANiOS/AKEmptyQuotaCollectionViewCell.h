//
//  AKEmptyQuotaCollectionViewCell.h
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKQuota.h"

@interface AKEmptyQuotaCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic)AKQuota *quota;

-(void)imageForQuotaValue;
@end
