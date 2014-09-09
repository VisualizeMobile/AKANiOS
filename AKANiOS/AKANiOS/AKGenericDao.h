//
//  AKGenericDao.h
//  AKAN
//
//  Created by Matheus Fonseca on 08/09/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AKGenericDaoRunOnMainThreadBlock)(void);

@interface AKGenericDao : NSObject
-(void) performOnMOCThread: (AKGenericDaoRunOnMainThreadBlock)block;
@end
