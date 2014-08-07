//
//  AKToolBar.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 07/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKToolBar.h"
#import "AKUtil.h"

@implementation AKToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"AKToolBar" owner:self options:nil] firstObject];
        self.backgroundColor = [AKUtil color3];
    }
    return self;
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
