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
#import "Parlamentary.h"

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
        singleton.fetchRequest =[[NSFetchRequest alloc]init];
        
        //Recupera tabla no aplicativo
        
        singleton.entity=[NSEntityDescription entityForName:@"Parlamentary" inManagedObjectContext:singleton.managedObjectContext];
        
        

        
    }
    
    return singleton;
}

-(NSArray *)getAllParliamentary{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    AKParliamentary *p1 = [[AKParliamentary alloc] init];
    p1.name = @"Romario de souza";
    [array addObject:p1];
    AKParliamentary *p2 = [[AKParliamentary alloc] init];
    p2.name = @"Roberto Pinto";
    [array addObject:p2];
    AKParliamentary *p3 = [[AKParliamentary alloc] init];
    p3.name = @"Rud Van Els";
    [array addObject:p3];
    
    return array;
}

-(BOOL)insertParlamentaryWithNickName:(NSString *)NickName andIdParlamentary:(NSString *)idParlamentary
{
    Parlamentary *newParlamentary =[NSEntityDescription insertNewObjectForEntityForName:@"Parlamentary" inManagedObjectContext:self.managedObjectContext];
    
    newParlamentary.nickName=NickName;
    newParlamentary.idParlamentary=idParlamentary;
    
    NSError *Error=nil;
    
    
    //Realiza insert no bando de dados local
    if ([self.managedObjectContext save:&Error])
        return YES;
    else NSLog(@"Failed to save the new parlamentary Error= %@",Error);
    
    
    
    return NO;
    
}

-(NSArray *)selectParlamentaryOfId:(NSString *)idParlamentary
{
    
 //   Parlamentary *parlamentary=[NSEntityDescription insertNewObjectForEntityForName:@"Parlamentary" inManagedObjectContext:self.managedObjectContext];
   
    
    
    [self.fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParlamentary==%@",idParlamentary]];
    [self.fetchRequest setEntity:self.entity];
    
    NSError *Error=nil;
    NSArray *result=[self.managedObjectContext executeFetchRequest:self.fetchRequest error:&Error];
    
    return result;
}

@end
