//
//  AKQuotaCollectionViewCell.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 07/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import "AKQuotaCollectionViewCell.h"
#import "AKUtil.h"

@implementation AKQuotaCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"AKQuotaCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1)
            return nil;
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
            return nil;
        
        self = [arrayOfViews objectAtIndex:0];
        
    }
    return self;

}


-(void)awakeFromNib{
    
}

#pragma mark - custom methods

-(void)imageForQuotaValue{
    self.imageView.image = [UIImage imageNamed:[self.quota imageName]];
    self.imageView.backgroundColor = [self colorForQuotaValue];
    self.valueLabel.text = [NSString stringWithFormat:@"R$ %@",[self.quota value]];
    self.valueLabel.textColor = [self colorForQuotaValue];
    self.levelImageView.image = [self.levelImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.levelImageView.tintColor = [self colorForQuotaValue];
    [self setLevelHeight];
}

-(void)setLevelHeight{
    float maxValue = 10000.00;
    float multiplier = [self.quota.value floatValue] * 100 / maxValue;
    CGFloat height = (multiplier <= 100)? multiplier : 100;
    NSLog(@"valor: %@ e percetual: %.2f",self.quota.value, height);
    self.levelImageView.frame = CGRectMake(0,103*(1 - height/100), 130, height);
}

-(UIColor *)colorForQuotaValue{
    switch ([[self.quota imageColor] intValue]) {
        case 1:
            return [AKUtil color4];
            break;
        case 2:
            return [AKUtil color1];
            break;
        case 3:
            return [AKUtil color3];
            break;
        case 4:
            return [AKUtil color2];
            break;
        case 5:
            return [AKUtil color5];
            break;
        default:
            return [AKUtil color1];
            break;
    }
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
