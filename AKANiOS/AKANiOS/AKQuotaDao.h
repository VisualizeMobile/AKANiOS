//
//  AKQuotaDao.h
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKGenericDao.h"

@interface AKQuotaDao : AKGenericDao <NSFetchedResultsControllerDelegate>

@property(nonatomic,strong) NSFetchedResultsController *quotaFRC;

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;//Acessa as tabelas
@property(nonatomic,strong) NSEntityDescription *entity ; //Representa a tabelas

+ (instancetype)getInstance;

-(BOOL)insertQuotaWithId: (NSNumber *)idQuota andValue:(NSDecimalNumber *) value;
-(BOOL)insertQuotaWithId:(NSNumber *)idQuota andNumQuota:(NSNumber *)numQuota andNameQuota:(NSString *)nameQuota andMonth:(NSNumber *)month andYear:(NSNumber *)year andIdUpdate:(NSNumber *)idUpdate andValue:(NSDecimalNumber *)value andIdParliamentary:(NSNumber *)idParliamentary;
-(BOOL)updateQuotaById:(NSNumber *)idQuota updateValue:(NSDecimalNumber *)value updateIdUpdate:(NSNumber *)idUpdate;
-(BOOL) deleteQuotasByIdParliamentary:(NSNumber *)idParliamentary;
-(BOOL) deleteAllQuotas;

-(NSArray *)getQuotas;
-(NSArray *) getQuotaByIdParliamentary:(NSNumber *)idParliamentary;
-(NSArray *) getQuotasByIdParliamentary:(NSNumber *)idParliamentary withNumQuota:(NSNumber*)numQuota andYear:(NSNumber *)year;
-(NSNumber *)getOldestYear;

@end
