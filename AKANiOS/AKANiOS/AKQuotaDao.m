//
//  AKQuotaDao.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKQuotaDao.h"
#import "AKQuota.h"
#import "AKAppDelegate.h"
#import "Quota.h"

@implementation AKQuotaDao

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
    static AKQuotaDao *singleton;
    AKAppDelegate *appDelegate;
    
    if (singleton == nil) @synchronized (self)
    {
        singleton = [[AKQuotaDao alloc] initPrivate];
        
        singleton.quotaFRC.delegate = singleton;
        
        appDelegate=[[UIApplication sharedApplication] delegate];
        
        singleton.managedObjectContext=appDelegate.managedObjectContext;
        singleton.fetchRequest =[[NSFetchRequest alloc]init];
        
        //Recupera tabla no aplicativo
        singleton.entity=[NSEntityDescription entityForName:@"Quota" inManagedObjectContext:singleton.managedObjectContext];
    }
    
    return singleton;
}

-(NSArray *)getQuotas{
    NSMutableArray *quotas = [[NSMutableArray alloc] init];
    
    AKQuota *q1 = [[AKQuota alloc] init];
    q1.value = 0.0;
    q1.subtype = 1;
    AKQuota *q2 = [[AKQuota alloc] init];
    q2.value = 2000.00;
    q2.subtype = 2;
    AKQuota *q3 = [[AKQuota alloc] init];
    q3.value = 1000.00;
    q3.subtype = 3;
    AKQuota *q4 = [[AKQuota alloc] init];
    q4.value = 2000.00;
    q4.subtype = 4;
    AKQuota *q5 = [[AKQuota alloc] init];
    q5.value = 300.00;
    q5.subtype = 5;
    AKQuota *q6 = [[AKQuota alloc] init];
    q6.value = 0.0;
    q6.subtype = 6;
    
    [quotas addObject:q1];
    [quotas addObject:q2];
    [quotas addObject:q3];
    [quotas addObject:q4];
    [quotas addObject:q5];
    [quotas addObject:q6];
    
    return quotas;
}

-(BOOL)insertQuotaWithId:(NSString *)idQuota andValue:(NSDecimalNumber * )value
{
    Quota *newQuota=[NSEntityDescription insertNewObjectForEntityForName:@"Quota" inManagedObjectContext:self.managedObjectContext];
    
    [newQuota setIdQuota:idQuota];
    [newQuota setValue:value];
    
    NSError *Error=nil;
    
    if ([self.managedObjectContext save:&Error])
    
        return YES;
    else NSLog(@"Failed to save new Quota  Error= %@",Error);
    
    return NO;
}
-(BOOL)insertQuotaWithId:(NSString *)idQuota andNumQuota:(NSNumber *)numQuota andNameQuota:(NSString *)nameQuota andMonth:(NSNumber *)month andYear:(NSNumber *)year andIdUpdate:(NSNumber *)idUpdate andValue:(NSDecimalNumber *)value andIdParliamentary:(NSString *)idParliamentary
{
    
    Quota *newQuota=[NSEntityDescription insertNewObjectForEntityForName:@"Quota" inManagedObjectContext:self.managedObjectContext];
    
    [newQuota setIdQuota:idQuota];
    [newQuota setNumQuota:numQuota];
    [newQuota setNameQuota: nameQuota];
    [newQuota setMonth:month];
    [newQuota setYear:year];
    [newQuota setIdUpdate:idUpdate];
    [newQuota setValue:value];
    [newQuota setIdParliamentary:idParliamentary];
    
    NSError *Error=nil;
    
    if ([self.managedObjectContext save:&Error])
        return YES;
    else NSLog(@"Failed to save new Quota  Error= %@",Error);

    return NO;
}

/*
 @property (nonatomic, retain) NSString * idParliamentary;
 @property (nonatomic, retain) NSString * idQuota;
 @property (nonatomic, retain) NSNumber * month;
 @property (nonatomic, retain) NSString * nameQuota;
 @property (nonatomic, retain) NSNumber * numQuota;
 @property (nonatomic, retain) NSDecimalNumber * value;
 @property (nonatomic, retain) NSNumber * year;
 @property (nonatomic, retain) NSNumber * idUpdate;

 
 */

-(NSArray *)selectQuotaById:(NSString *)idQuota
{
    NSArray *result;
    NSError *Error=nil;
    [self.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idQuota==%@",idQuota]];
    [self.fetchRequest setEntity:self.entity];
    
    
    result=[[self.managedObjectContext executeFetchRequest:self.fetchRequest error:&Error]objectAtIndex:0];
    
    return result;
}

-(NSArray *)selectAllQuotas
{
    NSArray *result;
    NSError *Error=nil;
    
    [self.fetchRequest setEntity:self.entity];
    
    result=[self.managedObjectContext executeFetchRequest:self.fetchRequest error:&Error];
    
    return result;
}

-(BOOL)updateQuotaById:(NSString *)idQuota updateValue:(NSDecimalNumber *)value updateIdUpdate:(NSNumber *)idUpdate
{
    NSError *Error=nil;
    Quota *quota;
    NSArray *result;
    
    [self.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idQuota==%@",idQuota]];
    result=[self.managedObjectContext executeFetchRequest:self.fetchRequest error:&Error];
    
    quota=[result objectAtIndex:0];
    quota.value=value;
    quota.idUpdate=idUpdate;
    
    if ([self.managedObjectContext save:&Error])
        return YES;
    else NSLog(@"Failed to uptade Quota");
    return NO;
}


@end
