//
//  AKAppDelegate.m
//  AKANiOS
//
//  Created by VisualizeMobile on 28/07/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKAppDelegate.h"
#import "AKMainListViewController.h"
#import "AKUtil.h"
#import "AKSettingsManager.h"
#import "AKParliamentaryDao.h"
#import "AKDetailViewController.h"

@interface AKAppDelegate()

@property AKMainListViewController *root;
@property UINavigationController *nav;

@end

@implementation AKAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self copyAppConfigurationFromBundleToDocuments];
    [self createParliamentaryPhotoDirectory];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
        

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([application currentUserNotificationSettings].types == 0 &&
           [defaults objectForKey:@"already_alerted_about_notifications"] == nil &&
           [defaults objectForKey:@"already_asked_for_notifications"] != nil
           ) {
            
            [defaults setBool:YES forKey:@"already_alerted_about_notifications"];
            [defaults synchronize];
            
            UIAlertView *ableNotificationsAlert = [[UIAlertView alloc] initWithTitle:@"Notificação de atualização" message:@"Caso deseje ser notificado quando um parlamentar realizar um novo gasto, habilite isso em Ajustes > AKAN > Notificações > Permitir Notificações." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [ableNotificationsAlert show];
        }
        
        [defaults setBool:YES forKey:@"already_asked_for_notifications"];
        [defaults synchronize];
    }
    
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        NSNumber *idParliamentary = [notification.userInfo objectForKey:@"idParliamentary"];
        
        if(idParliamentary)
            self.root.idParliamentaryFromNotification = idParliamentary;
        
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.root =  [[AKMainListViewController alloc] init];
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:self.root];
    self.nav.navigationBar.barTintColor = [AKUtil color1];
    self.nav.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [AKUtil color4]};
    self.nav.navigationBar.tintColor = [AKUtil color4];
    
    self.window.rootViewController = self.nav;
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSNumber *idParliamentary = [notification.userInfo objectForKey:@"idParliamentary"];
    
    if (idParliamentary)
    {
        UIApplicationState state = [application applicationState];
        if (state == UIApplicationStateInactive) {
            AKDetailViewController *detailController = [[AKDetailViewController alloc] init];
            
            AKParliamentaryDao *dao = [AKParliamentaryDao getInstance];
            
            detailController.parliamentary = [dao getParliamentaryWithId:idParliamentary];
            
            [self.nav pushViewController:detailController animated:YES];
            
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
                
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)copyAppConfigurationFromBundleToDocuments {
    BOOL alreadyExists;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    alreadyExists = [fileManager fileExistsAtPath:[AKSettingsManager settingsFilePath]];
    
    if (alreadyExists)
        return;
    
    NSString *filePathMainBundle = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"akan_settings.plist"];
    
    [fileManager copyItemAtPath:filePathMainBundle toPath:[AKSettingsManager settingsFilePath] error:nil];
}

- (void)createParliamentaryPhotoDirectory {
    BOOL alreadyExists;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    alreadyExists = [fileManager fileExistsAtPath:[AKSettingsManager photoCacheDirPath]];
    
    if (alreadyExists)
        return;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[AKSettingsManager photoCacheDirPath] withIntermediateDirectories:NO attributes:nil error:nil];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AKANiOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationLibraryDirectory] URLByAppendingPathComponent:@"AKANiOS.sqlite"];
    
    NSError *error = nil;
    
    NSMutableDictionary *options = nil;
    options = [NSMutableDictionary dictionary];
    [options setValue:[NSNumber numberWithBool:YES]
               forKey:NSMigratePersistentStoresAutomaticallyOption];
    [options setValue:[NSNumber numberWithBool:YES]
               forKey:NSInferMappingModelAutomaticallyOption];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

        // If Unresolved error, thean delete old store (will lose data) and create another one
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's directories

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationLibraryDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
