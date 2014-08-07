//
//  AKTableViewCell.h
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *parliamentaryName;
@property (weak, nonatomic) IBOutlet UILabel *ufLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *parliamentaryPhoto;

@end
