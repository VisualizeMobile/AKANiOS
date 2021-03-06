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
#import "AKUtil.h"

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
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSError *error=nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        
        //Verifico se o parlamentar ja existe no device
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
        [fetchRequest setEntity:self.entity];
        
        NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([result count]==0)
        {
            AKParliamentary *newParliamentary =[NSEntityDescription insertNewObjectForEntityForName:@"Parliamentary"inManagedObjectContext:self.managedObjectContext];
            
            newParliamentary.nickName=NickName;
            newParliamentary.idParliamentary=idParliamentary;
            
            if ([self.managedObjectContext save:&error]) {
                success = YES;
            } else {
                NSLog(@"Failed to save the new parlamentary Error= %@",error);
                success = NO;
            }
                
            
        }
    }];
    
    return success;
}

-(BOOL) insertParliamentaryWithNickName:(NSString *)nickName andIdParliamentary:(NSNumber *) idParliamentary andParty:(NSString *)party andPosRanking:(NSNumber *)posRanking andUf:(NSString *)uf andValueRanking:(NSDecimalNumber *)valueRanking andFollowed:(NSNumber *) followed
{
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSError *error=nil;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        //Verifico se o parlamentar ja existe no device
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
        [fetchRequest setEntity:self.entity];
        
        NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
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
            if ([self.managedObjectContext save:&error]) {
                success = YES;
            } else {
                NSLog(@"Failed to save the new parlamentary Error= %@",error);
                success = NO;
            }
            
            
        }
    }];
    
    return success;
}

-(BOOL)updateParliamentary:(NSNumber *)idParliamentary withPhoto:(NSData *)photoData {
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
        [fetchRequest setEntity:self.entity];
        
        NSError *Error=nil;
        NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
        
        AKParliamentary *parliamentary=[result objectAtIndex:0];
        
        parliamentary.photoParliamentary=photoData;
        
        if ([self.managedObjectContext save:&Error]) {
            success = YES;
        } else {
            NSLog(@"Failed to update the parlamentary Error= %@",Error);
            success = NO;
        }
    }];
    
    return success;
}

-(AKParliamentary*) getParliamentaryWithId:(NSNumber*) idParliamentary;
{
    __block NSArray *result = nil;
    [self performOnMOCThread: ^(void) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
        [fetchRequest setEntity:self.entity];
        
        result=[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    }];
    
    return [result firstObject];
}


-(NSArray *)getAllParliamentary
{
    __block NSArray *result = nil;
    [self performOnMOCThread: ^(void) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        
        [fetchRequest setEntity:self.entity];
        NSError *Error=nil;
        
        result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    }];
    
    return result;
}

-(NSArray *)getAllFollowedPartliamentary {
    __block NSArray *result = nil;
    [self performOnMOCThread: ^(void) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        
        [fetchRequest setEntity:self.entity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"followed==1"]];
        
        result=[self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    }];
    
    return result;
}

-(BOOL)updateFollowedByIdParliamentary:(NSNumber *)idParliamentary andFollowedValue:(NSNumber *)followedValue
{
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
        [fetchRequest setEntity:self.entity];
        
        NSError *error=nil;
        NSArray *result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        AKParliamentary *parliamentary=[result objectAtIndex:0];
        
        parliamentary.followed=followedValue;
        
        if ([self.managedObjectContext save:&error]) {
            success = YES;
        } else {
            NSLog(@"Failed to update the parlamentary Error= %@",error);
            success = NO;
        }
        
    }];
    

    
    return success;
}

-(NSArray*) getAllParliamentaryParties {
    __block NSMutableArray *result = nil;
    [self performOnMOCThread: ^(void) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        
        [fetchRequest setEntity:self.entity];
        NSError *Error=nil;
        NSArray *allParliamentary=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
        
         result = [NSMutableArray new];
        
        for(AKParliamentary *parliamentary in allParliamentary) {
            if(![result containsObject:parliamentary.party])
                [result addObject: parliamentary.party];
        }
        
        [result sortUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = (NSString*)a;
            NSString *second = (NSString*)b;
            return [first compare:second];
        }];
    }];
    
    return result;
}

-(NSArray*) getAllParliamentaryStates {
    __block NSMutableArray *result = nil;
    
    [self performOnMOCThread: ^(void) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        
        [fetchRequest setEntity:self.entity];
        NSError *Error=nil;
        NSArray *allParliamentary=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
        
        result = [NSMutableArray new];
        
        for(AKParliamentary *parliamentary in allParliamentary) {
            if(![result containsObject:parliamentary.uf])
                [result addObject: parliamentary.uf];
        }
        
        [result sortUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = (NSString*)a;
            NSString *second = (NSString*)b;
            return [first compare:second];
        }];
    }];
    
    return result;
}


-(BOOL) deleteAllPariamentary {
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
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
        if ([self.managedObjectContext save:&saveError]) {
            success = YES;
        } else {
            NSLog(@"Failed to update the parlamentary Error= %@",saveError);
            success = NO;
        }
    }];
    
    return success;
}

@end
