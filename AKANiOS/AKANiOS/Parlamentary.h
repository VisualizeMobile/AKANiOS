//
//  Parlamentary.h
//  AKANiOS
//
//  Created by Ramon Cruz on 8/12/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Parlamentary : NSManagedObject

@property (nonatomic, retain) NSString * idParlamentary;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * urlPhoto;
@property (nonatomic, retain) NSString * party;
@property (nonatomic, retain) NSString * uf;
@property (nonatomic, retain) NSString * fullName;
@property (nonatomic, retain) NSNumber * posRanking;
@property (nonatomic, retain) NSDecimalNumber * valueRanking;

@end
