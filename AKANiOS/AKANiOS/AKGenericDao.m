//
//  AKGenericDao.m
//  AKAN
//
//  Created by Matheus Fonseca on 08/09/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKGenericDao.h"
#import "AKUtil.h"
@implementation AKGenericDao

-(void) performOnMOCThread: (AKGenericDaoRunOnMainThreadBlock)block {
    if([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@end
