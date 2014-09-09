//
//  AKStatistic.m
//  AKAN
//
//  Created by Arthur Jahn Sturzbecher on 27/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKStatistic.h"
#import "NSManagedObject+PerformOnMOCThread.h"


@implementation AKStatistic

@dynamic max_value;
@dynamic average;
@dynamic numQuota;
@dynamic year;
@dynamic month;
@dynamic stdDeviation;

-(NSDecimalNumber *) max_value {
    __block NSDecimalNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"max_value"];
    }];
    
    return primitive;
}
-(NSDecimalNumber *) average {
    __block NSDecimalNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"average"];
    }];
    
    return primitive;
}
-(NSNumber *) numQuota {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"numQuota"];
    }];
    
    return primitive;
}
-(NSNumber *) year {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"year"];
    }];
    
    return primitive;
}
-(NSNumber *) month {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"month"];
    }];
    
    return primitive;
}
-(NSNumber *) stdDeviation {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"stdDeviation"];
    }];
    
    return primitive;
}

@end
