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
@property(nonatomic,strong) NSFetchRequest *fetchRequest; // para fazer selects etc..
@property(nonatomic,strong) NSEntityDescription *entity ; //Representa a tabelas

+ (instancetype)getInstance;
-(NSArray *)getQuotas;

-(BOOL) insertQuotaWithId: (NSString *)idQuota andValue:(double) value;
-(NSArray *) selectQuotaById:(NSString *)idQuota ;

@end
