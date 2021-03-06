//
//  AKQuotaCollectionViewCell.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 07/08/14.
//  Copyright (c) 2014 Arthur Jahn Sturzbecher. All rights reserved.
//

#import "AKQuotaCollectionViewCell.h"
#import "AKUtil.h"

//confiabiliti limit for the probabilistic estimation
double const confiability = 1.4;

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

-(void) prepareForReuse {
    self.levelImageView.frame = CGRectZero;
    [self.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
}

- (void)drawRect:(CGRect)rect
{
    [self setLevelHeight];
}

#pragma mark - custom methods

-(void)imageForQuotaValue{
    self.maxValue = self.average + confiability*self.stdDeviation;
    self.imageView.image = [UIImage imageNamed:[self.quota imageName]];
    
    self.valueLabel.textColor = [AKUtil color4];
    self.levelImageView.tintColor = [AKUtil color4];
    self.imageView.backgroundColor = [AKUtil color4];

    
    NSNumberFormatter *numberFormatter=[[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    numberFormatter.minimumFractionDigits = 2;
    
    //self.valueLabel.text = [NSString stringWithFormat:@"R$ %@", [numberFormatter stringFromNumber: [self.quota value]]];
    self.levelImageView.image = [self.levelImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self setLevelHeight];
    [self setNeedsDisplay];
}

-(void)setLevelHeight{
    float multiplier = [self exponentialProbability]*100;
    CGFloat height = (multiplier <= 100)? multiplier : 100;
    self.levelImageView.frame = CGRectMake(0, 103, 130, 0);

    [self generateColorsAnimation];
    [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveLinear animations:
        ^(void){
            [self countFrom:0.0 to:[self.quota.value floatValue] withDuration:50.0f];
            self.levelImageView.frame = CGRectMake(0,103*(1 - height/100), 130, height);
        }
        completion:nil];
}

-(void)generateColorsAnimation{
    NSMutableArray *colors = [self colorForQuotaValue];
    for (int i = 0; i<[colors count]; i++) {
        UIColor *color = (UIColor *)colors[i];
        [self performSelector:@selector(animateColor:) withObject:color afterDelay:0.5*i];
    }
}

-(NSMutableArray *)colorForQuotaValue{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    double probability = [self exponentialProbability];
    //NSLog(@"%.2lf",probability);
    if (self.quota.value > 0) {
        [colors addObject: [AKUtil color3]];
    }
    if(probability  >= 0.25){
        [colors addObject: [AKUtil color1]];
    }
    if(probability >= 0.5){
        [colors addObject: [AKUtil color2]];
    }
    if(probability >= 0.75){
        [colors addObject: [AKUtil color5]];
    }
    return colors;
}

-(void)animateColor:(UIColor *) color{
    [UIView animateWithDuration:0.4
                     animations:^(void){
                         self.levelImageView.tintColor = color;
                         self.valueLabel.textColor = color;
                         self.imageView.backgroundColor = color;
                     }
                     completion:nil];
}

-(double) exponentialProbability{
    double lambda = 1/self.average;
    double result = 1 - exp(-lambda*[self.quota.value doubleValue]);
    //NSLog(@"%f",result);
    return result;
}

#pragma mark - counting label methods

-(void)countFrom:(float)startValue to:(float)endValue withDuration:(NSTimeInterval)duration
{
    if(duration == 0.0){
        // No animation
        [self setTextValue:endValue];
        return;
    }
    
    self.startingValue = startValue;
    self.destinationValue = endValue;
    self.progress = 0;
    self.totalTime = duration;
    self.lastUpdate = [NSDate timeIntervalSinceReferenceDate];
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:(1.0f/60.0f) target:self selector:@selector(updateValue:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
}

-(void)updateValue:(NSTimer*)timer
{
    // update progress
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    self.progress += now - self.lastUpdate;
    self.lastUpdate = now;
    
    if(self.progress >= self.totalTime)
    {
        [timer invalidate];
        self.progress = self.totalTime;
    }
    
    float percent = self.progress / self.totalTime;
    float updateVal = percent;
    float value =  self.startingValue +  (updateVal * (self.destinationValue - self.startingValue));
    
    [self setTextValue:value];
    
}

- (void)setTextValue:(float)value
{

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *stringValue = [formatter stringFromNumber:[NSNumber numberWithDouble:value]];
    
    self.valueLabel.text = stringValue;
}
@end
