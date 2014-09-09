//
//  AKQuota.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 26/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKQuota.h"
#import "NSManagedObject+PerformOnMOCThread.h"

@implementation AKQuota

@dynamic idParliamentary;
@dynamic idQuota;
@dynamic idUpdate;
@dynamic imageColor;
@dynamic imageName;
@dynamic month;
@dynamic nameQuota;
@dynamic numQuota;
@dynamic value;
@dynamic year;

-(NSNumber *) idParliamentary {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"idParliamentary"];
    }];
    
    return primitive;
}
-(NSNumber *) idQuota {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"idQuota"];
    }];
    
    return primitive;
}
-(NSNumber *) idUpdate {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"idUpdate"];
    }];
    
    return primitive;
}
-(NSNumber *) imageColor {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"imageColor"];
    }];
    
    return primitive;
}
-(NSString *) imageName {
    __block NSString *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"imageName"];
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
-(NSString *) nameQuota {
    __block NSString *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"nameQuota"];
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
-(NSDecimalNumber *) value {
    __block NSDecimalNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"value"];
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

@end
