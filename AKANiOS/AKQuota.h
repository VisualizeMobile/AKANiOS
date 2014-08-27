//
//  AKQuota.h
//  AKANiOS
//
//  Created by Matheus Fonseca on 26/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AKQuota : NSManagedObject

@property (nonatomic, retain) NSNumber * idParliamentary;
@property (nonatomic, retain) NSNumber * idQuota;
@property (nonatomic, retain) NSNumber * idUpdate;
@property (nonatomic, retain) NSNumber * imageColor;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * month;
@property (nonatomic, retain) NSString * nameQuota;
@property (nonatomic, retain) NSNumber * numQuota;
@property (nonatomic, retain) NSDecimalNumber * value;
@property (nonatomic, retain) NSNumber * year;

@end
