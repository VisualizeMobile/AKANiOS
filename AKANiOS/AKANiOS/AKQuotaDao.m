//
//  AKQuotaDao.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKQuotaDao.h"
#import "AKQuota.h"

@implementation AKQuotaDao

- (instancetype)init
{
    @throw [[NSException alloc] initWithName:@"Singleton Violation"
                                      reason:@"Use getInstance instead of init method"
                                    userInfo:nil];
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if(self){
    }
    return self;
}

+ (instancetype)getInstance
{
    static AKQuotaDao *singleton;
    
    if (singleton == nil) @synchronized (self)
    {
        singleton = [[AKQuotaDao alloc] initPrivate];
    }
    
    return singleton;
}

-(NSArray *)getQuotas{
    NSMutableArray *quotas = [[NSMutableArray alloc] init];
    
    AKQuota *q1 = [[AKQuota alloc] init];
    q1.value = 0.0;
    q1.subtype = 1;
    AKQuota *q2 = [[AKQuota alloc] init];
    q2.value = 2000.00;
    q2.subtype = 2;
    AKQuota *q3 = [[AKQuota alloc] init];
    q3.value = 1000.00;
    q3.subtype = 3;
    AKQuota *q4 = [[AKQuota alloc] init];
    q4.value = 2000.00;
    q4.subtype = 4;
    AKQuota *q5 = [[AKQuota alloc] init];
    q5.value = 300.00;
    q5.subtype = 5;
    AKQuota *q6 = [[AKQuota alloc] init];
    q6.value = 0.0;
    q6.subtype = 6;
    
    [quotas addObject:q1];
    [quotas addObject:q2];
    [quotas addObject:q3];
    [quotas addObject:q4];
    [quotas addObject:q5];
    [quotas addObject:q6];
    
    return quotas;
}

@end
