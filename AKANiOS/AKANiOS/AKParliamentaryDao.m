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
#import "Parliamentary.h"

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
        singleton.parlamentaryFRC.delegate = singleton;
    
        appDelegate=[[UIApplication sharedApplication] delegate];
    
        singleton.managedObjectContext=appDelegate.managedObjectContext;
        singleton.fetchRequest =[[NSFetchRequest alloc]init];
        
        //Recupera tabla no aplicativo
        
        singleton.entity=[NSEntityDescription entityForName:@"Parliamentary" inManagedObjectContext:singleton.managedObjectContext];
    }
    
    return singleton;
}

-(NSArray *)getAllParliamentary{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 0; i < 1000; i++) {
        AKParliamentary *p1 = [[AKParliamentary alloc] init];
        p1.name = @"Romario de souza";
        [array addObject:p1];
    }
    
    return array;
}

-(BOOL)insertParliamentaryWithNickName:(NSString *)NickName andIdParliamentary:(NSString *)idParliamentary
{
    Parliamentary *newParliamentary =[NSEntityDescription insertNewObjectForEntityForName:@"Parliamentary" inManagedObjectContext:self.managedObjectContext];
    
    newParliamentary.nickName=NickName;
    newParliamentary.idParliamentary=idParliamentary;
    
    NSError *Error=nil;
    
    
    //Realiza insert no bando de dados local
    if ([self.managedObjectContext save:&Error])
        return YES;
    else NSLog(@"Failed to save the new parlamentary Error= %@",Error);
    
    
    
    return NO;
    
}
-(BOOL)insertParliamentaryWithNickName:(NSString *)nickName andFullName:(NSString *)fullName andIdParliamentary:(NSString *) idParliamentary andParty:(NSString *)party andPosRanking:(NSNumber *)posRanking andUf:(NSString *)uf andUrlPhoto:(NSString *)urlPhoto andValueRanking:(NSDecimalNumber *)valueRanking andIdUpdate:(NSNumber *) idupdate andFollowed:(NSNumber *) followed
{
    Parliamentary *newParliamentary=[NSEntityDescription insertNewObjectForEntityForName:@"Parliamentary" inManagedObjectContext:self.managedObjectContext];
    
    [newParliamentary setNickName:nickName];
    [newParliamentary setFullName:fullName];
    [newParliamentary setIdParliamentary:idParliamentary];
    [newParliamentary setParty:party];
    [newParliamentary setPosRanking:posRanking];
    [newParliamentary setUf:uf];
    [newParliamentary setUrlPhoto:urlPhoto];
    [newParliamentary setValueRanking:valueRanking];
    [newParliamentary setIdUpdate:idupdate];
    [newParliamentary setFollowed:followed];
    
    NSError *Error=nil;
    
    //Realiza insert no banco de dados local
    if ([self.managedObjectContext save:&Error])
    
        return YES;
    else NSLog(@"Failed to save the new parlamentary Error= %@",Error);

    return  NO;
}

-(NSArray *)selectAllParliamentaries
{
    [self.fetchRequest setEntity:self.entity];
    NSError *Error=nil;
    NSArray *result=[self.managedObjectContext executeFetchRequest:self.fetchRequest error:&Error];
    return result;
}

-(NSArray *)selectParliamentaryById:(NSString *)idParliamentary
{
    
    [self.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [self.fetchRequest setEntity:self.entity];
    
    NSError *Error=nil;
    NSArray *result=[[self.managedObjectContext executeFetchRequest:self.fetchRequest error:&Error] objectAtIndex:0];
    
    return result;
}

-(BOOL)updateIdUpdateOfParliamentary:(NSString *)idParliamentary WithIdUpdate:(NSNumber *)idUpdate
{
    [self.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [self.fetchRequest setEntity:self.entity];
    
    NSError *Error=nil;
    NSArray *result=[self.managedObjectContext executeFetchRequest:self.fetchRequest error:&Error];
    
    Parliamentary *parliamentary=[result objectAtIndex:0];
    
    parliamentary.idUpdate=idUpdate;
    
    if ([self.managedObjectContext save:&Error])
        return  YES;
    else NSLog(@"Failed to update the parlamentary Error= %@",Error);
    
    
    return NO;
}

@end
