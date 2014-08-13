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
    for(int i = 0; i < 1000; i++) {
        AKParliamentary *p1 = [[AKParliamentary alloc] init];
        p1.name = @"Romario de souza";
        [array addObject:p1];
    }
    
    return array;
}

@end
