//
//  AKParliamentaryService.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 25/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKWebServiceConsumer.h"
#import "Reachability.h"

NSString const* urlBase = @"http://107.170.177.5:8000/akan";

@implementation AKWebServiceConsumer

-(void) downloadDataWithPath:(NSString*) dataPath andFinishBlock:(AKWebServiceFinishedDownload)finishedBlock {
    NSString *dataUrl = [NSString stringWithFormat:@"%@%@", urlBase, dataPath];
    
    NSURL *url = [NSURL URLWithString:dataUrl];
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error != nil) {
            NSLog(@"%s Connection error: %@", __FUNCTION__, [error localizedDescription]);
            
            Reachability *_reachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus remoteHostStatus = [_reachability currentReachabilityStatus];

            if (remoteHostStatus == NotReachable) {
                finishedBlock(nil, NO, YES);
            } else {
                finishedBlock(nil, NO, NO);
            }
            
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
        if([httpResponse statusCode] >= 400) {
            NSLog(@"%s HTTP status code error: %ld", __FUNCTION__, (long) [httpResponse statusCode]);
            
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
