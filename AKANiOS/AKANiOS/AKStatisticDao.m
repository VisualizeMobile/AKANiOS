//
//  AKStatisticDao.m
//  AKAN
//
//  Created by Arthur Jahn Sturzbecher on 27/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKStatisticDao.h"
#import "AKStatistic.h"
#import "AKAppDelegate.h"

@implementation AKStatisticDao

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
    static AKStatisticDao *singleton;
    AKAppDelegate *appDelegate;
    
    if (singleton == nil) @synchronized (self)
    {
        singleton = [[AKStatisticDao alloc] initPrivate];
        
        singleton.statisticFRC.delegate = singleton;
        
        appDelegate=[[UIApplication sharedApplication] delegate];
        
        singleton.managedObjectContext=appDelegate.managedObjectContext;
        
        //Recupera tabla no aplicativo
        singleton.entity=[NSEntityDescription entityForName:@"Statistic" inManagedObjectContext:singleton.managedObjectContext];
    }
    
    return singleton;
}

-(BOOL)insertStatisticWithNumQuota:(NSNumber *)numQuota andMaxValue:(NSDecimalNumber *)maxValue andAverage:(NSDecimalNumber *)average andStdDeviation:(double)stdDeviation{
    
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSArray *result;
        NSError *error = nil;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(numQuota == %@) AND (year == 0)", numQuota]];
        [fetchRequest setEntity:self.entity];
        
        result = [self.managedObjectContext executeFetchRequest:fetchRequest error: &error];
        
        if([result count] == 0){
            AKStatistic *statistic = [NSEntityDescription insertNewObjectForEntityForName:@"Statistic" inManagedObjectContext:self.managedObjectContext];
            [statistic setNumQuota:numQuota];
            [statistic setYear:@0];
            [statistic setMax_value:maxValue];
            [statistic setAverage:average];
            [statistic setStdDeviation: [NSNumber numberWithDouble: stdDeviation ]];
            
            if ([self.managedObjectContext save:&error]) {
                success =  YES;
            } else {
                success = NO;
                NSLog(@"Failed to save new Quota  Error= %@",error);
            }
        }
    }];
    
    return  success;
}

-(BOOL)insertStatisticWithNumQuota:(NSNumber *)numQuota andMonth:(NSNumber *)month andYear:(NSNumber *)year andMaxValue:(NSDecimalNumber *)maxValue andAverage:(NSDecimalNumber *)average{
    
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSArray *result;
        NSError *error = nil;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"numQuota == %@ and year == %@ and month == %@", numQuota,year,month]];
        [fetchRequest setEntity:self.entity];
        
        result = [self.managedObjectContext executeFetchRequest:fetchRequest error: &error];
        
        if([result count] == 0){
            AKStatistic *statistic = [NSEntityDescription insertNewObjectForEntityForName:@"Statistic" inManagedObjectContext:self.managedObjectContext];
            [statistic setNumQuota:numQuota];
            [statistic setMax_value:maxValue];
            [statistic setAverage:average];
            [statistic setMonth:month];
            [statistic setYear:year];
            
            if ([self.managedObjectContext save:&error]) {
                success =   YES;
            }
            else {
                NSLog(@"Failed to save new Quota  Error= %@",error);
                success = NO;
            }
        }
    }];
    
    return  success;
}

-(BOOL)deleteAllStatistic {
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSError *error=nil;
        NSArray *result;
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        
        [request setEntity:self.entity];
        [request setIncludesPropertyValues:NO]; // only fetch the managedObjectID
        
        @try {
            result=[self.managedObjectContext executeFetchRequest:request error:&error];
            
            for(AKStatistic *statistic in result)
            {
                [self.managedObjectContext deleteObject:statistic];
            }
            
            if ([self.managedObjectContext save:&error]) {
                
                success = YES;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Failed to delete Statistic Error:%@",exception);
            success = NO;
        }
    }];
    
    return success;
}

-(NSArray *) getStatisticByYear:(NSNumber *)year
{
    __block NSArray *result;
    [self performOnMOCThread: ^(void) {
        NSError *error=nil;
        
        NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"year==%@",year]];
        [fetchRequest setEntity:self.entity];
        
        result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return result;
}

-(NSArray *) getStatisticByYear:(NSNumber *)year andNumQuota:(NSNumber *)numQuota
{
    __block NSArray *result;
    [self performOnMOCThread: ^(void) {
        NSError *Error=nil;
        
        NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(year == %@) AND (numQuota == %@)",year,numQuota]];
        [fetchRequest setEntity:self.entity];
        
        result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    }];
    
    return result;
}

@end
