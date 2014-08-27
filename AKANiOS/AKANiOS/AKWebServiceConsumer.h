//
//  AKParliamentaryService.h
//  AKANiOS
//
//  Created by Matheus Fonseca on 25/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AKWebServiceFinishedDownload)(NSArray*, BOOL, BOOL);

@interface AKWebServiceConsumer : NSObject

-(void) downloadDataWithPath:(NSString*) dataPath andFinishBlock:(AKWebServiceFinishedDownload)finishedBlock;

@end
