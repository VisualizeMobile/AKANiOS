//
//  AKParliamentary.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 26/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKParliamentary.h"


@implementation AKParliamentary

@dynamic followed;
@dynamic fullName;
@dynamic idParliamentary;
@dynamic nickName;
@dynamic party;
@dynamic photoParliamentary;
@dynamic posRanking;
@dynamic uf;
@dynamic valueRanking;

-(NSNumber*) followed {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"followed"];
    }];
    
    return primitive;
}
-(NSString*) fullName {
    __block NSString *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"fullName"];
    }];
    
    return primitive;
}
-(NSNumber*) idParliamentary {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"idParliamentary"];
    }];
    
    return primitive;
}
-(NSString*) nickName {
    __block NSString *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"nickName"];
    }];
    
    return primitive;
}
-(NSString*) party {
    __block NSString *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"party"];
    }];
    
    return primitive;
}
-(NSData*) photoParliamentary {
    __block NSData *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"photoParliamentary"];
    }];
    
    return primitive;
}
-(NSNumber*) posRanking {
    __block NSNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"posRanking"];
    }];
    
    return primitive;
}
-(NSString*) uf {
    __block NSString *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"uf"];
    }];
    
    return primitive;
}
-(NSDecimalNumber*) valueRanking {
    __block NSDecimalNumber *primitive = nil;
    
    [self performOnMOCThread:^() {
        primitive = [self primitiveValueForKey:@"valueRanking"];
    }];
    
    return primitive;
}

@end
