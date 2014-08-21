//
//  AKTableViewCell.m
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKMainTableViewCell.h"
#import "AKUtil.h"

@implementation AKMainTableViewCell

- (void)awakeFromNib
{
    self.parliamentaryPhoto.layer.cornerRadius = self.parliamentaryPhoto.frame.size.height /2;
    self.parliamentaryPhoto.layer.masksToBounds = YES;
    self.parliamentaryPhoto.layer.borderWidth = 1;
    self.parliamentaryPhoto.layer.borderColor = [AKUtil color1].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
