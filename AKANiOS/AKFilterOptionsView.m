//
//  AKFilterOptionsView.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 20/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKFilterOptionsView.h"
#import "AKUtil.h"

@interface AKFilterOptionsView()

@property(nonatomic) CGFloat upperIndicatorXPosition;

@end

@implementation AKFilterOptionsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [AKUtil color4];
        self.layer.cornerRadius = 3; // if you like rounded corners
        self.layer.shadowOffset = CGSizeMake(0, 20);
        self.layer.shadowRadius = 10;
        self.layer.shadowOpacity = 0.4;
    }
    
    return self;
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

@end
