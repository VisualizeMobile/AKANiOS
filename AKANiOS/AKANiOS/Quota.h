//
//  Quota.h
//  AKANiOS
//
//  Created by Ramon Cruz on 8/12/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Quota : NSManagedObject

@property (nonatomic, retain) NSString * idQuota;
@property (nonatomic, retain) NSNumber * numQuota;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSString * nameQuota;
@property (nonatomic, retain) NSString * idParlamentary;
@property (nonatomic, retain) NSDecimalNumber * value;

@end
