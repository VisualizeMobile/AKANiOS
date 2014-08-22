//
//  AKQuotaDao.h
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKQuotaDao : NSObject <NSFetchedResultsControllerDelegate>

@property(nonatomic,strong) NSFetchedResultsController *quotaFRC;

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;//Acessa as tabelas
@property(nonatomic,strong) NSEntityDescription *entity ; //Representa a tabelas

+ (instancetype)getInstance;
-(NSArray *)getQuotas;

-(BOOL)insertQuotaWithId: (NSString *)idQuota andValue:(NSDecimalNumber *) value;
-(BOOL)insertQuotaWithId:(NSString *)idQuota andNumQuota:(NSNumber *)numQuota andNameQuota:(NSString *)nameQuota andMonth:(NSNumber *)month andYear:(NSNumber *)year andIdUpdate:(NSNumber *)idUpdate andValue:(NSNumber *)value andIdParliamentary:(NSString *)idParliamentary;

-(BOOL)updateQuotaById:(NSString *)idQuota updateValue:(NSDecimalNumber *)value updateIdUpdate:(NSNumber *)idUpdate;
-(NSArray *) getQuotaByIdParliamentary:(NSString *)idParliamentary;

-(BOOL) deleteQuotaByIdParliamentary:(NSString *)idParliamentary;

-(BOOL)insertQuotasFromArray:(NSArray *)quotas;
@end
