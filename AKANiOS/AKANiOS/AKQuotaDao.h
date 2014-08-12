//
//  AKQuotaDao.h
//  AKANiOS
//
//  Created by Arthur Jahn Sturzbecher on 08/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKQuotaDao : NSObject <NSFetchedResultsControllerDelegate>

+ (instancetype)getInstance;

-(NSArray *)getQuotas;
@end
