//
//  AKStatistic.h
//  AKAN
//
//  Created by Arthur Jahn Sturzbecher on 27/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AKStatistic : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * max_value;
@property (nonatomic, retain) NSDecimalNumber * average;
@property (nonatomic, retain) NSNumber * numQuota;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSNumber * stdDeviation;

@end
