//
//  AKFilterOptionCollectionViewCell.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 20/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKFilterOptionCollectionViewCell.h"
#import "AKUtil.h"
@implementation AKFilterOptionCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [AKUtil color1];
    self.layer.masksToBounds = NO;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.75;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.cornerRadius = 2; // if you like rounded corners

    self.textLabel.textColor = [AKUtil color4];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    self.backgroundColor = [AKUtil color1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
