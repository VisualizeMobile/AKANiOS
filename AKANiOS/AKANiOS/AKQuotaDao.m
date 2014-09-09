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
        
        singleton.quotaFRC.delegate=singleton;
        
        appDelegate=[[UIApplication sharedApplication] delegate];
        
        singleton.managedObjectContext=appDelegate.managedObjectContext;
        
        //Recupera tabla no aplicativo
        singleton.entity=[NSEntityDescription entityForName:@"Quota" inManagedObjectContext:singleton.managedObjectContext];
    }
    
    return singleton;
}


-(BOOL)insertQuotaWithId:(NSNumber *)idQuota andValue:(NSDecimalNumber * )value
{
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSError *error=nil;
        NSArray *result = nil;
        
        NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idQuota==%@",idQuota]];
        [fetchRequest setEntity:self.entity];
        
        result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([result count]==0)
        {
            AKQuota *newQuota=[NSEntityDescription insertNewObjectForEntityForName:@"Quota" inManagedObjectContext:self.managedObjectContext];
            
            [newQuota setIdQuota:idQuota];
            [newQuota setValue:value];
            
            if ([self.managedObjectContext save:&error]) {
                success = YES;
            }
            else {
                NSLog(@"Failed to save new Quota  Error= %@",error);
               success = NO;
            }
        }
    }];
    
    return success;
}

-(BOOL)insertQuotaWithId:(NSNumber *)idQuota andNumQuota:(NSNumber *)numQuota andNameQuota:(NSString *)nameQuota andMonth:(NSNumber *)month andYear:(NSNumber *)year andIdUpdate:(NSNumber *)idUpdate andValue:(NSDecimalNumber *)value andIdParliamentary:(NSNumber *)idParliamentary
{
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSString *quotaName = [self subtypeNameOfSubtype:[numQuota intValue]];
        
        NSArray *result;
        NSError *error=nil;
        
        NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idQuota==%@",idQuota]];
        [fetchRequest setEntity:self.entity];
        
        result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([result count]==0)
        {
            AKQuota *newQuota=[NSEntityDescription insertNewObjectForEntityForName:@"Quota" inManagedObjectContext:self.managedObjectContext];
            NSString *nameImage;
            
            [newQuota setIdQuota:idQuota];
            [newQuota setNumQuota:numQuota];
            [newQuota setNameQuota: quotaName];
            [newQuota setMonth:month];
            [newQuota setYear:year];
            [newQuota setIdUpdate:idUpdate];
            [newQuota setValue:value];
            [newQuota setIdParliamentary:idParliamentary];
            [newQuota setImageColor:[self imageColorOfValue:value]];
            
            nameImage=[self imageNameOfSubtype:[[newQuota numQuota] intValue]];
            [newQuota setImageName:nameImage];
            
            if ([self.managedObjectContext save:&error]) {
                success = YES;
            } else {
                NSLog(@"Failed to save new Quota  Error= %@",error);
                success = NO;
            }
        }
    }];
    
    return success;
}

-(NSNumber *)verifyNumQuota:(NSNumber *)numQuota{
    if ([numQuota isEqual: @120] || [numQuota isEqual: @121] || [numQuota isEqual: @122] || [numQuota isEqual: @123]) {
        return @15;
    }else if ([numQuota isEqual: @999]){
        return @9;
    }
    return numQuota;
}

-(BOOL)updateQuotaById:(NSString *)idQuota updateValue:(NSDecimalNumber *)value updateIdUpdate:(NSNumber *)idUpdate
{
    NSError *Error=nil;
    AKQuota *quota;
    NSArray *result;
    NSString *nameImage;
    
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idQuota==%@",idQuota]];
    [fetchRequest setEntity:self.entity];
    @try {
        result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
        quota=[result objectAtIndex:0];
        quota.value=value;
        quota.idUpdate=idUpdate;
        
        nameImage=[self imageNameOfSubtype:[quota.numQuota intValue]];
        quota.imageName=nameImage;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Error update quota; Error=%@",exception);
    }
    if ([self.managedObjectContext save:&Error])
    return YES;
    else
    NSLog(@"Failed to uptade Quota");
    
    return NO;
}


-(NSArray *) getQuotaByIdParliamentary:(NSNumber *)idParliamentary
{
    NSArray *result;
    NSError *Error=nil;
    
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [fetchRequest setEntity:self.entity];
    
    result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    return result;
}


-(NSArray *) getQuotasByIdParliamentary:(NSNumber *)idParliamentary withNumQuota:(NSNumber*) numQuota andYear:(NSNumber *)year
{
    __block NSArray *result = nil;
    [self performOnMOCThread: ^(void) {
        NSError *error=nil;
        
        NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(idParliamentary==%@) AND (numQuota==%@) AND (year == %@)",idParliamentary, numQuota, year]];
        [fetchRequest setEntity:self.entity];
        
        result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return result;
}

-(NSArray *)getQuotas
{
    __block NSArray *result = nil;
    [self performOnMOCThread: ^(void) {
        NSError *error=nil;
        
        NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
        [fetchRequest setEntity:self.entity];
        result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
        
    return result;
}


-(BOOL) deleteAllQuotas {
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSError *error=nil;
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        NSArray *result = nil;
        
        [request setEntity:self.entity];
        
        @try {
            result=[self.managedObjectContext executeFetchRequest:request error:&error];
            
            for(AKQuota *quota in result)
            {
                [self.managedObjectContext deleteObject:quota];
            }
            
            if ([self.managedObjectContext save:&error]) {
                success = YES;
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"Failed to delete Quota Error:%@",exception);
            success = NO;
        }
    }];
    
    return success;
}
-(BOOL) deleteQuotasByIdParliamentary:(NSNumber *)idParliamentary
{
    __block BOOL success;
    [self performOnMOCThread: ^(void) {
        NSError *error=nil;
        NSArray *result;
        
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        [request setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
        [request setEntity:self.entity];
        
        @try {
            result=[self.managedObjectContext executeFetchRequest:request error:&error];
            
            for(AKQuota *quota in result)
            {
                [self.managedObjectContext deleteObject:quota];
            }
            
            if ([self.managedObjectContext save:&error]) {
                
                success = YES;
            }
            
        }
        @catch (NSException *exception) {
            NSLog(@"Failed to delete Quota Error:%@",exception);
            success = NO;
        }
    }];
    
    return NO;
}

-(NSString *)subtypeNameOfSubtype:(int)subtype{
    switch (subtype) {
        case 1:
            return @"Escritório";
            break;
        case 3:
            return @"Combustível";
            break;
        case 4:
            return @"Pesquisas e Consultorias";
            break;
        case 5:
            return @"Divulgação";
            break;
        case 8:
            return @"Segurança";
            break;
        case 9:
            return @"Passagens Aéreas";
            break;
        case 10:
            return @"Telefonia";
            break;
        case 11:
            return @"Serviços Postais";
            break;
        case 12:
            return @"Assinatura de Publicações";
            break;
        case 13:
            return @"Alimentação";
            break;
        case 14:
            return @"Hospedagem";
            break;
        case 15:
            return @"Locação de Veículos";
            break;
        case 119:
            return @"Fretamento de Aeronaves";
            break;
        default:
            return @"Nenhum";
            break;
    }
}


-(NSString *)imageNameOfSubtype:(int)subtype{
    switch (subtype) {
        case 1:
            return @"escritorio";
            break;
        case 3:
            return @"combustivel";
            break;
        case 4:
            return @"consultoria";
            break;
        case 5:
            return @"divulgacao";
            break;
        case 8:
            return @"seguranca";
            break;
        case 9:
            return @"passagem";
            break;
        case 10:
            return @"telefonia";
            break;
        case 11:
            return @"postais";
            break;
        case 12:
            return @"assinaturas";
            break;
        case 13:
            return @"alimentacao";
            break;
        case 14:
            return @"hospedagem";
            break;
        case 15:
            return @"automovel";
            break;
        case 119:
            return @"aeronaves";
            break;
        default:
            return [NSString stringWithFormat: @"nenhum: %d", subtype ];
            break;
    }
    
}

-(NSNumber *)imageColorOfValue:(NSNumber *)value{
    if ([value floatValue] < 1.0f) {
        return @1;
    }else if([value floatValue] < 1500.0f){
        return @2;
    }else if([value floatValue] < 3000.0f){
        return @3;
    }else if([value floatValue] < 6000.0f){
        return @4;
    }else {
        return @5;
    }
}

-(NSNumber *)getOldestYear {
    NSArray *quotas = [self getQuotas];
    
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"year" ascending:YES]];
    
    quotas = [quotas sortedArrayUsingDescriptors:sortDescriptors];
    
    if(quotas.count>0) {
        AKQuota *quota = [quotas objectAtIndex:0];
    
        return quota.year;
    }
    
    return 0;
}

@end
