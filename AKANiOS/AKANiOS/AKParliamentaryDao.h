//
//  AKParliamentaryDao.h
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKParliamentary.h"
#import "AKGenericDao.h"

@interface AKParliamentaryDao : AKGenericDao <NSFetchedResultsControllerDelegate>

@property(nonatomic,strong) NSFetchedResultsController *parlamentaryFRC;
@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;//Acessa as tabelas
@property(nonatomic,strong) NSEntityDescription *entity ; //Representa a tabelas
@property(nonatomic,strong) NSSortDescriptor *nickName; //Faz ordenacao (Order by)
@property(nonatomic,strong) NSArray *parlamentaresList; // Retorna uma lista com os parlamentares


+ (instancetype)getInstance;

-(BOOL) insertParliamentaryWithNickName:(NSString *) NickName andIdParliamentary:(NSNumber *) idParlamentary;
-(BOOL)insertParliamentaryWithNickName:(NSString *)nickName andIdParliamentary:(NSNumber *) idParliamentary andParty:(NSString *)party andPosRanking:(NSNumber *)posRanking andUf:(NSString *)uf andValueRanking:(NSDecimalNumber *)valueRanking andFollowed:(NSNumber *) followed;
-(BOOL)updateFollowedByIdParliamentary:(NSNumber *)idParliamentary andFollowedValue:(NSNumber *)followedValue;
-(BOOL)updateParliamentary:(NSNumber *)idParliamentary withPhoto:(NSData *)photoData;
-(BOOL) deleteAllPariamentary;

-(NSArray *)getAllParliamentary;
-(AKParliamentary*) getParliamentaryWithId:(NSNumber*) idParliamentary;
-(NSArray*) getAllParliamentaryParties;
-(NSArray*) getAllParliamentaryStates;
-(NSArray *)getAllFollowedPartliamentary;



@end
