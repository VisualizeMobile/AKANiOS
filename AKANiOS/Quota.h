//
//  Quota.h
//  AKANiOS
//
//  Created by Ramon Cruz on 8/18/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Quota : NSManagedObject

@property (nonatomic, retain) NSString * idParliamentary;
@property (nonatomic, retain) NSString * idQuota;
@property (nonatomic, retain) NSNumber * idUpdate;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSString * nameImage;
@property (nonatomic, retain) NSString * nameQuota;
@property (nonatomic, retain) NSNumber * numQuota;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * colorImage;

@end
