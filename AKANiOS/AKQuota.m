//
//  AKQuota.m
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKQuota.h"

@implementation AKQuota

-(BOOL)isEmpty{
    return (self.value == 0.0) ? YES : NO;
}
@end
