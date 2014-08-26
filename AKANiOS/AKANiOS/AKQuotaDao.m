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
#import "AKQuota.h"

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


-(BOOL)insertQuotaWithId:(NSString *)idQuota andValue:(NSDecimalNumber * )value
{
    
    NSArray *result;
    NSError *Error=nil;
    
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idQuota==%@",idQuota]];
    [fetchRequest setEntity:self.entity];
    
    
    result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    if ([result count]==0)
    {
        AKQuota *newQuota=[NSEntityDescription insertNewObjectForEntityForName:@"Quota" inManagedObjectContext:self.managedObjectContext];
        
        [newQuota setIdQuota:idQuota];
        [newQuota setValue:value];
        
        if ([self.managedObjectContext save:&Error])
            return YES;
        else
            NSLog(@"Failed to save new Quota  Error= %@",Error);
        
    } else NSLog(@"Ja tem essa cota");
   
    
    return NO;
}

-(BOOL)insertQuotaWithId:(NSString *)idQuota andNumQuota:(NSNumber *)numQuota andNameQuota:(NSString *)nameQuota andMonth:(NSNumber *)month andYear:(NSNumber *)year andIdUpdate:(NSNumber *)idUpdate andValue:(NSNumber *)value andIdParliamentary:(NSString *)idParliamentary
{
    NSArray *result;
    NSError *Error=nil;
    
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idQuota==%@",idQuota]];
    [fetchRequest setEntity:self.entity];
    
    result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];

    if ([result count]==0)
    {
        AKQuota *newQuota=[NSEntityDescription insertNewObjectForEntityForName:@"Quota" inManagedObjectContext:self.managedObjectContext];
        NSString *nameImage;
        
        [newQuota setIdQuota:idQuota];
        [newQuota setNumQuota:numQuota];
        [newQuota setNameQuota: nameQuota];
        [newQuota setMonth:month];
        [newQuota setYear:year];
        [newQuota setIdUpdate:idUpdate];
        [newQuota setValue:value];
        [newQuota setIdParliamentary:idParliamentary];
        [newQuota setImageColor:[self imageColorOfValue:value]];
        
        nameImage=[self imageNameOfSubtype:[[newQuota numQuota] intValue]];
        [newQuota setImageName:nameImage];
        
        
        if ([self.managedObjectContext save:&Error])
            return YES;
        else
            NSLog(@"Failed to save new Quota  Error= %@",Error);
        
    }
    
    return NO;
}


-(NSArray *) getQuotaByIdParliamentary:(NSString *)idParliamentary
{
    NSArray *result;
    NSError *Error=nil;
    
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [fetchRequest setEntity:self.entity];
    
    result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    return result;
}

-(NSArray *) getQuotasByIdParliamentary:(NSString *)idParliamentary withName:(NSString*)nameQuota
{
    NSArray *result;
    NSError *Error=nil;
    
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(idParliamentary==%@) AND (nameQuota==%@)",idParliamentary, nameQuota]];
    [fetchRequest setEntity:self.entity];
    
    result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    return result;
}

-(NSArray *)getQuotas
{
    NSArray *result;
    NSError *Error=nil;
    
    NSFetchRequest *fetchRequest =[[NSFetchRequest alloc]init];
    [fetchRequest setEntity:self.entity];
    result=[self.managedObjectContext executeFetchRequest:fetchRequest error:&Error];
    
    return result;
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

-(BOOL) deleteAllQuotas
{
    NSError *Error=nil;
    NSArray *result;
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    
    [request setEntity:self.entity];
    
    @try {
        result=[self.managedObjectContext executeFetchRequest:request error:&Error];
        
        for(AKQuota *quota in result)
        {
            [self.managedObjectContext deleteObject:quota];
        }
        
        if ([self.managedObjectContext save:&Error]) {
            
            return YES;
        }

        
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to delete Quota Error:%@",exception);
    }
    
    return NO;
}
-(BOOL) deleteQuotaByIdParliamentary:(NSString *)idParliamentary
{
    NSError *Error=nil;
    NSArray *result;
    
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setPredicate:[NSPredicate predicateWithFormat:@"idParliamentary==%@",idParliamentary]];
    [request setEntity:self.entity];
    
    @try {
        result=[self.managedObjectContext executeFetchRequest:request error:&Error];
        
        for(AKQuota *quota in result)
        {
            [self.managedObjectContext deleteObject:quota];
        }        
        
        if ([self.managedObjectContext save:&Error]) {
            
            return YES;
        }
        
    }
    @catch (NSException *exception) {
        
                NSLog(@"Failed to delete Quota Error:%@",exception);
    }
    
    
    return NO;
}


/*
 1 - passagens aéreas;
 2 - telefonia;
 3 - serviços postais, vedada a aquisição de selos;
 4 - manutenção de escritórios de apoio à atividade parlamentar, compreendendo locação de imóveis, pagamento de taxa de condomínio, IPTU, energia elétrica, água e esgoto, locação de móveis e equipamentos, material de expediente e suprimentos de informática, acesso à internet, assinatura de TV a cabo ou similar, locação ou aquisição de licença de uso de software, assinatura de publicações;
 5 - fornecimento de alimentação do parlamentar;
 6 - hospedagem, exceto do parlamentar no Distrito Federal;
 7 - locação ou fretamento de aeronaves, embarcações e veículos automotores (neste último caso, o ressarcimento é limitado ao percentual de 10% do valor do veículo conforme a tabela Fipe do mês utilizado pelo parlamentar);
 8 - combustíveis e lubrificantes, até o limite de R$ 4.500,00 mensais;
 9 - serviços de segurança, prestados por empresa especializada, até o limite inacumulável de R$ 4.500,00 mensais;
 10 - contratação, para fins de apoio ao exercício do mandato parlamentar, de consultorias e trabalhos técnicos, permitidas pesquisas socioeconômicas;
 11 - divulgação da atividade parlamentar, exceto nos 120 dias anteriores à data das eleições de âmbito federal, estadual ou municipal.
 */

-(NSString *)subtypeNameOfSubtype:(int)subtype{
    switch (subtype) {
        case 1:
            return @"Passagens Aereas";
            break;
        case 2:
            return @"Telefonia";
            break;
        case 3:
            return @"Serviços Postais";
            break;
        case 4:
            return @"Escritório";
            break;
        case 5:
            return @"Alimentação";
            break;
        case 6:
            return @"Hospedagem";
            break;
        case 7:
            return @"Locação de Aeronaves";
            break;
        case 8:
            return @"Locação de Automóveis";
            break;
        case 9:
            return @"Combustiveis";
            break;
        case 10:
            return @"Segurança";
            break;
        case 11:
            return @"Pesquisas";
            break;
        case 12:
            return @"Divulgação";
            break;
        case 13:
            return @"Assinaturas";
            break;
        default:
            return @"";
            break;
    }
}


-(NSString *)imageNameOfSubtype:(int)subtype{
    switch (subtype) {
        case 1:
            return @"passagem";
            break;
        case 2:
            return @"telefonia";
            break;
        case 3:
            return @"postais";
            break;
        case 4:
            return @"escritorio";
            break;
        case 5:
            return @"alimentacao";
            break;
        case 6:
            return @"hospedagem";
            break;
        case 7:
            return @"aeronaves";
            break;
        case 8:
            return @"automovel";
            break;
        case 9:
            return @"combustivel";
            break;
        case 10:
            return @"seguranca";
            break;
        case 11:
            return @"consultoria";
            break;
        case 12:
            return @"divulgacao";
            break;
        case 13:
            return @"assinaturas";
            break;
        default:
            return @"";
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

-(BOOL)insertQuotasFromArray:(NSArray *)quotas{
    //TODO implement persistence
    return YES;
}



@end
