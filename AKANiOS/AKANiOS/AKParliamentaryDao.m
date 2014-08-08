//
//  AKParliamentaryDao.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKParliamentaryDao.h"
#import "AKParliamentary.h"

@implementation AKParliamentaryDao

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
    static AKParliamentaryDao *singleton;
    
    if (singleton == nil) @synchronized (self)
    {
        singleton = [[AKParliamentaryDao alloc] initPrivate];
    }
    
    return singleton;
}

-(NSArray *)getAllParliamentary{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    AKParliamentary *p1 = [[AKParliamentary alloc] init];
    [array addObject:p1];
    AKParliamentary *p2 = [[AKParliamentary alloc] init];
    [array addObject:p2];
    AKParliamentary *p3 = [[AKParliamentary alloc] init];
    [array addObject:p3];
    
    return array;
}

@end
