//
//  AKAppDelegate.h
//  AKANiOS
//
//  Created by VisualizeMobile on 28/07/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
