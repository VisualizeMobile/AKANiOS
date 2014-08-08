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
    AKQuota *q2 = [[AKQuota alloc] init];
    AKQuota *q3 = [[AKQuota alloc] init];
    AKQuota *q4 = [[AKQuota alloc] init];
    AKQuota *q5 = [[AKQuota alloc] init];
    AKQuota *q6 = [[AKQuota alloc] init];
    
    [quotas addObject:q1];
    [quotas addObject:q2];
    [quotas addObject:q3];
    [quotas addObject:q4];
    [quotas addObject:q5];
    [quotas addObject:q6];
    
    
    return quotas;
}

@end
