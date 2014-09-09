//
//  AKParliamentary.h
//  AKANiOS
//
//  Created by Matheus Fonseca on 26/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+PerformOnMOCThread.h"

@interface AKParliamentary : NSManagedObject

@property (nonatomic, retain) NSNumber * followed;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSNumber * idParliamentary;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSData * photoParliamentary;
@property (nonatomic, retain) NSNumber * posRanking;
@property (nonatomic, retain) NSString * uf;
@property (nonatomic, retain) NSDecimalNumber * valueRanking;

@end
