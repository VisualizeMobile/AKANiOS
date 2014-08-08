//
//  AKParlamentary.m
//  AKANiOS
//
//  Created by Arthur Sturzbecher on 04/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKParliamentary.h"

@implementation AKParliamentary

-(NSString *)firstName{
    NSScanner *scanner = [NSScanner scannerWithString:self.name];
    NSString *substring = nil;
    while(![scanner isAtEnd]) {
        if([scanner scanUpToString:@" " intoString:&substring]) {
            break;
        }
    }
    return substring;
}

@end
