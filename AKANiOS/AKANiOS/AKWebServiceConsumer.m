//
//  AKParliamentaryService.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 25/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKWebServiceConsumer.h"
#import "Reachability.h"

NSString const* urlBase = @"http://107.170.177.5/akan";
//NSString const* urlBase = @"http://localhost:8000";

@implementation AKWebServiceConsumer

-(void) downloadDataWithPath:(NSString*) dataPath andFinishBlock:(AKWebServiceFinishedDownload)finishedBlock {
    
    NSString *dataUrl = [NSString stringWithFormat:@"%@%@", urlBase, dataPath];
    NSURL *url = [NSURL URLWithString:dataUrl];
    
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForResource = 60.0f;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    NSURLSessionDataTask *downloadTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error != nil) {
            NSLog(@"%s Connection error (%ld): %@", __FUNCTION__, (long)error.code, [error localizedDescription]);
            
            if(error.code == -1001) {
                finishedBlock(nil, NO, YES);
                return;
            }
            
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            if ( (reachability.currentReachabilityStatus == NotReachable) ||
                ((reachability.currentReachabilityStatus == ReachableViaWWAN) && reachability.connectionRequired == YES) ) {
                NSLog(@"%s Reachability error: No internet connection", __FUNCTION__);
                finishedBlock(nil, NO, YES);
                
                return;
            }
            
            finishedBlock(nil, NO, NO);
            
            return;
        }
        
        NSError *parseError;
        NSArray *jsonArray = [NSJSONSerialization
                                           JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers
                                           error:&parseError];
        if(parseError != nil) {
            NSLog(@"%s Parse error: %@", __FUNCTION__, [parseError localizedDescription]);

            finishedBlock(nil, NO, NO);
            return;
        }
        
        finishedBlock(jsonArray, YES, NO);
    }];

    [downloadTask resume];
}

@end
