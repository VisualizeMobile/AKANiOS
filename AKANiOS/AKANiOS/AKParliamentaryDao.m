//
//  AKParliamentaryDao.m
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKParliamentaryDao.h"
#import "AKParliamentary.h"
#import "AKAppDelegate.h"
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
    AKAppDelegate *appDelegate;
    
    if (singleton == nil) @synchronized (self)
    {
        singleton = [[AKParliamentaryDao alloc] initPrivate];
        singleton.parlamentaryFRC.delegate=singleton;
    
        appDelegate=[[UIApplication sharedApplication] delegate];
    
        singleton.managedObjectContext=appDelegate.managedObjectContext;
        
        //Recupera tabla no aplicativo
        
        singleton.entity=[NSEntityDescription entityForName:@"Parliamentary" inManagedObjectContext:singleton.managedObjectContext];
    }
    
    return singleton;
}


-(BOOL)insertParliamentaryWithNickName:(NSString *)NickName andIdParliamentary:(NSNumber *)idParliamentary
{
    NSError *Error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    //Verifico se o parlamentar ja existe no device
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [fetchRequest setEntity:self.entity];
    
    NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    if ([result count]==0)
    {
        AKParliamentary *newParliamentary =[NSEntityDescription insertNewObjectForEntityForName:@"Parliamentary"inManagedObjectContext:self.managedObjectContext];
        
        newParliamentary.nickName=NickName;
        newParliamentary.idParliamentary=idParliamentary;
        
        if ([self.managedObjectContext save:&Error])
            return YES;
        else
            NSLog(@"Failed to save the new parlamentary Error= %@",Error);
        
        return NO;

    }
    
    return NO;
    
}
-(BOOL)insertParliamentaryWithNickName:(NSString *)nickName andIdParliamentary:(NSNumber *) idParliamentary andParty:(NSString *)party andPosRanking:(NSNumber *)posRanking andUf:(NSString *)uf andValueRanking:(NSDecimalNumber *)valueRanking andFollowed:(NSNumber *) followed
{
    
    NSError *Error=nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    //Verifico se o parlamentar ja existe no device
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [fetchRequest setEntity:self.entity];
    
    NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    if ([result count]==0) {
        AKParliamentary *newParliamentary=[NSEntityDescription insertNewObjectForEntityForName:@"Parliamentary" inManagedObjectContext:self.managedObjectContext];
        
        [newParliamentary setNickName:nickName];
        [newParliamentary setFullName:nickName];
        [newParliamentary setIdParliamentary:idParliamentary];
        [newParliamentary setParty:party];
        [newParliamentary setPosRanking:posRanking];
        [newParliamentary setUf:uf];
        [newParliamentary setValueRanking:valueRanking];
        [newParliamentary setFollowed:followed];
        
        //Realiza insert no banco de dados local
        if ([self.managedObjectContext save:&Error])
            return YES;
        else
            NSLog(@"Failed to save the new parlamentary Error= %@",Error);

    }
    
    return  NO;
}

-(BOOL)updateParliamentary:(NSNumber *)idParliamentary withPhoto:(NSData *)photoData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [fetchRequest setEntity:self.entity];
    
    NSError *Error=nil;
    NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    AKParliamentary *parliamentary=[result objectAtIndex:0];
    
    parliamentary.photoParliamentary=photoData;
    
    if ([self.managedObjectContext save:&Error])
        return  YES;
    else
        NSLog(@"Failed to update the parlamentary Error= %@",Error);
    
    
    return NO;

    
}

-(AKParliamentary*) getParliamentaryWithId:(NSNumber*) idParliamentary;
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [fetchRequest setEntity:self.entity];
    
    NSError *Error=nil;
    NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];

    return [result firstObject];
}


-(NSArray *)getAllParliamentary
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    [fetchRequest setEntity:self.entity];
    NSError *Error=nil;
    NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    return result;
}

-(NSArray *)getAllFollowedPartliamentary {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    [fetchRequest setEntity:self.entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"followed==1"]];

    NSError *Error=nil;
    NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    return result;
}


-(NSArray *)selectParliamentaryById:(NSNumber *)idParliamentary
{
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [fetchRequest setEntity:self.entity];
    
    NSError *Error=nil;
    NSArray *result=[[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error] objectAtIndex:0];
    
    return result;
}


-(BOOL)updateFollowedByIdParliamentary:(NSNumber *)idParliamentary andFollowedValue:(NSNumber *)followedValue
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [fetchRequest setEntity:self.entity];
    
    NSError *Error=nil;
    NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    AKParliamentary *parliamentary=[result objectAtIndex:0];
    
    parliamentary.followed=followedValue;
    
    if ([self.managedObjectContext save:&Error])
        return  YES;
    else
        NSLog(@"Failed to update the parlamentary Error= %@",Error);

    
    return NO;
}

-(NSArray*) getAllParliamentaryParties {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    [fetchRequest setEntity:self.entity];
    NSError *Error=nil;
    NSArray *allParliamentary=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    NSMutableArray *result = [NSMutableArray new];
    
    for(AKParliamentary *parliamentary in allParliamentary) {
        if(![result containsObject:parliamentary.party])
            [result addObject: parliamentary.party];
    }
    
    [result sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = (NSString*)a;
        NSString *second = (NSString*)b;
        return [first compare:second];
    }];
    
    return result;
}

-(NSArray*) getAllParliamentaryStates {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    [fetchRequest setEntity:self.entity];
    NSError *Error=nil;
    NSArray *allParliamentary=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    NSMutableArray *result = [NSMutableArray new];
    
    for(AKParliamentary *parliamentary in allParliamentary) {
        if(![result containsObject:parliamentary.uf])
            [result addObject: parliamentary.uf];
    }
    
    [result sortUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = (NSString*)a;
        NSString *second = (NSString*)b;
        return [first compare:second];
    }];
    
    return result;
}


-(void) deleteAllPariamentary {
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:self.entity];
    [fetch setIncludesPropertyValues:NO]; // only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * parliamentaryArray = [self.managedObjectContext executeFetchRequest:fetch error:&error];

    //error handling goes here
    for (NSManagedObject *parliamentary in parliamentaryArray) {
        [self.managedObjectContext deleteObject:parliamentary];
    }
    
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
}

@end
