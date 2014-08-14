//
//  AKParliamentaryDao.h
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKParliamentaryDao : NSObject <NSFetchedResultsControllerDelegate>

@property(nonatomic,strong) NSFetchedResultsController *parlamentaryFRC;

@property(nonatomic,strong) NSManagedObjectContext *managedObjectContext;//Acessa as tabelas
@property(nonatomic,strong) NSFetchRequest *fetchRequest; // para fazer selects etc..
@property(nonatomic,strong) NSEntityDescription *entity ; //Representa a tabelas
@property(nonatomic,strong) NSSortDescriptor *nickName; //Faz ordenacao (Order by)
@property(nonatomic,strong) NSArray *parlamentaresList; // Retorna uma lista com os parlamentares


+ (instancetype)getInstance;

-(NSArray *)getAllParliamentary;


-(BOOL) insertParliamentaryWithNickName:(NSString *) NickName andIdParliamentary:(NSString *) idParlamentary;

-(BOOL)insertParliamentaryWithNickName:(NSString *)nickName andFullName:(NSString *)fullName andIdParliamentary:(NSString *) idParliamentary andParty:(NSString *)party andPosRanking:(NSNumber *)posRanking andUf:(NSString *)uf andUrlPhoto:(NSString *)urlPhoto andValueRanking:(NSNumber *)valueRanking andIdUpdate:(NSNumber *) iduptade andFollowed:(NSNumber *) followed;

-(NSArray *) selectParliamentaryById:(NSString *)idParliamentary;
-(NSArray *)selectAllParliamentaries;

-(BOOL)updateIdUpdateOfParliamentary:(NSString *)idParliamentary WithIdUpdate:(NSNumber *)idUpdate;

@end
