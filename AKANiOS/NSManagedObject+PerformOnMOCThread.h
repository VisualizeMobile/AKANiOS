//
//  NSManagedObject+PerformOnMOCThread.h
//  AKAN
//
//  Created by Matheus Fonseca on 08/09/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef void (^AKPerformOnMOCThreadBlock)(void);

@interface NSManagedObject (PerformOnMOCThread)

-(void) performOnMOCThread: (AKPerformOnMOCThreadBlock)block;

@end
