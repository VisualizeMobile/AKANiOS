//
//  AKQuota.h
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKQuota : NSObject

@property (nonatomic) double value;
@property (nonatomic) int subtype;

-(BOOL)isEmpty;

-(NSString *)imageName;
-(NSString *)imageColor;
@end
