//
//  AKStatisticDao.h
//  AKAN
//
//  Created by Arthur Jahn Sturzbecher on 27/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKStatisticDao : NSObject<NSFetchedResultsControllerDelegate>

@property(nonatomic,strong) NSFetchedResultsController *statisticFRC;

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;//Acessa as tabelas
@property(nonatomic,strong) NSEntityDescription *entity ; //Representa a tabelas

+ (instancetype)getInstance;

-(BOOL)insertStatisticWithNumQuota:(NSNumber *)numQuota andMonth:(NSNumber *)month andYear:(NSNumber *)year andMaxValue:(NSDecimalNumber *)maxValue andAverage:(NSDecimalNumber *)average;
-(BOOL)insertStatisticWithNumQuota:(NSNumber *)numQuota andMaxValue:(NSDecimalNumber *)maxValue andAverage:(NSDecimalNumber *)average andStdDeviation:(double )stdDeviation;
-(BOOL) deleteAll;
-(NSArray *) getStatisticByYear:(NSNumber *)year;
-(NSArray *) getStatisticByYear:(NSNumber *)year andNumQuota:(NSNumber *)numQuota;

@end
