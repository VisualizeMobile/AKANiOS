//
//  AKTableViewCell.h
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *parlamentaryName;
@property (weak, nonatomic) IBOutlet UILabel *ufLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *parlamentaryPhoto;

@end
