//
//  NSManagedObject+PerformOnMOCThread.m
//  AKAN
//
//  Created by Matheus Fonseca on 08/09/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "NSManagedObject+PerformOnMOCThread.h"

@implementation NSManagedObject (PerformOnMOCThread)

-(void) performOnMOCThread: (AKPerformOnMOCThreadBlock)block {
    if([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
        
    }
}

@end
