//
//  AKQuotaCollectionViewCell.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 07/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import "AKQuotaCollectionViewCell.h"
#import "AKUtil.h"
@interface AKQuotaCollectionViewCell()

@property float maxValue;

@end
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

- (void)drawRect:(CGRect)rect
{
    [self setLevelHeight];
}

#pragma mark - custom methods

-(void)imageForQuotaValue{
    self.maxValue = self.average + 1.5*self.stdDeviation;
    self.imageView.image = [UIImage imageNamed:[self.quota imageName]];
    self.imageView.backgroundColor = [self colorForQuotaValue];
    NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    numberFormatter.minimumFractionDigits = 2;
    
    self.valueLabel.text = [NSString stringWithFormat:@"R$ %@", [numberFormatter stringFromNumber: [self.quota value]]];
    self.valueLabel.textColor = [self colorForQuotaValue];
    self.levelImageView.image = [self.levelImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.levelImageView.tintColor = [self colorForQuotaValue];
    [self setLevelHeight];
}

-(void)setLevelHeight{
    float multiplier = [self exponentialProbabilityForLimit:self.maxValue]*100;
    CGFloat height = (multiplier <= 100)? multiplier : 100;
    self.levelImageView.frame = CGRectMake(0,103, 130, 0);
    //NSLog(@"%f",height);
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:
     ^(void){
         self.levelImageView.frame = CGRectMake(0,103*(1 - height/100), 130, height);
     }
    completion:nil];
}

-(UIColor *)colorForQuotaValue{
    double probability = [self exponentialProbabilityForLimit:self.maxValue];
    //NSLog(@"%.2lf",probability);
    if (self.quota.value <= 0) {
        return [AKUtil color4];
    }
    else if(probability < 0.25){
        return [AKUtil color3];
    }
    else if(probability < 0.5){
        return [AKUtil color1];
    }
    else if(probability< 0.75){
        return [AKUtil color2];
    }
    else{
        return [AKUtil color5];
    }
}

-(double) exponentialProbabilityForLimit:(double)upperLimit{
    double lambda = 1/self.maxValue;
    double result = 1 - exp(-lambda*[self.quota.value doubleValue]);
    NSLog(@"%f",result);
    return result;
}

@end
