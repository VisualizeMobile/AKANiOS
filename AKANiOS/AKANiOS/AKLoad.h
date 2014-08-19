//
//  AKLoad.h
//  AKANiOS
//
//  Created by Ramon Cruz on 8/18/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKQuotaDao.h"
#import "AKParliamentaryDao.h"


@interface AKLoad : NSObject

@property(nonatomic) AKQuotaDao *quotaDao;
@property(nonatomic) AKParliamentaryDao *parliamentaryDao;

-(void)loadParliamentariesTestData;
-(void)loadQuotasTestData;


@end
