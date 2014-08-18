//
//  AKParliamentary.h
//  AKANiOS
//
//  Created by Ramon Cruz on 8/18/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AKParliamentary : NSManagedObject

@property (nonatomic, retain) NSNumber * followed;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSString * idParliamentary;
@property (nonatomic, retain) NSNumber * idUpdate;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSData * photoParliamentary;
@property (nonatomic, retain) NSNumber * posRanking;
@property (nonatomic, retain) NSString * uf;
@property (nonatomic, retain) NSString * urlPhoto;
@property (nonatomic, retain) NSNumber * valueRanking;

@end
