//
//  AKFilterOptionsUpperDetailView.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 20/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//


#import "AKFilterOptionsUpperTriangleView.h"
#import "AKUtil.h"

@interface AKFilterOptionsUpperTriangleView()

@property(nonatomic) CGFloat upperIndicatorXPosition;

@end

@implementation AKFilterOptionsUpperTriangleView

- (id)initWithFrame:(CGRect)frame andFilterIconXAxysCenter:(CGFloat)xAxysCenter {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [AKUtil color1];
        self.upperIndicatorXPosition = xAxysCenter-11;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth=1;
    [path moveToPoint:CGPointMake(self.upperIndicatorXPosition, self.bounds.origin.y)];
    [path addLineToPoint:CGPointMake(self.upperIndicatorXPosition-25, self.bounds.origin.y+self.frame.size.height)];
    [path addLineToPoint:CGPointMake(self.upperIndicatorXPosition+25, self.bounds.origin.y+self.frame.size.height)];
    [path closePath];
    
    [[AKUtil color4] set];
    [path stroke];
    [path fill];
}

@end
