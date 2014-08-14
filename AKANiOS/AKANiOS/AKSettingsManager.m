//
//  AKSettingsManager.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 13/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKSettingsManager.h"

@interface AKSettingsManager ()

@end

@implementation AKSettingsManager

-(id) init {
    @throw [NSException exceptionWithName: @"AKSettingsManagerInitException"
                                   reason: @"Method \"-init\" is not allowed, use \"+sharedManager\" instead"
                                 userInfo: nil];
}

+ (AKSettingsManager*)sharedManager {
    static AKSettingsManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    
    return sharedMyManager;
}

-(AKSettingsSortOption) getSortOption {
    return 0;
}

-(AKSettingsFilterQuotaOption) getQuotaFilter {
    return 0;
}

-(NSArray*) getStatesFilter {
    return nil;
}

-(NSArray*) getPartiesFilter {
    return nil;
}


-(void) setSortOption:(AKSettingsSortOption) sortOption {
    
}

-(void) setQuotaFilter:(AKSettingsFilterQuotaOption) quotaFilter {
    
}

-(void) setStatesFilter:(NSArray*) statesFilter {
    
}

-(void) setPartiesFilter:(NSArray*) partiesFilter {
    
}

-(void) addPartyFilter:(NSString*) partieFilter {
    
}

-(void) addStateFilter:(NSString*) stateFilter {
    
}


@end
