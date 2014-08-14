//
//  AKSettingsManager.h
//  AKANiOS
//
//  Created by Matheus Fonseca on 13/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(char, AKSettingsSortOption) {
    AKSettingsSortOptionRanking, AKSettingsSortOptionName,
    AKSettingsSortOptionParty, AKSettingsSortOptionState
};

typedef NS_ENUM(char, AKSettingsFilterQuotaOption) {
    AKSettingsFilterQuotaOptionNone, AKSettingsFilterQuotaOption10,
    AKSettingsFilterQuotaOption30, AKSettingsFilterQuotaOption50,
    AKSettingsFilterQuotaOption80
};

@interface AKSettingsManager : NSObject

+(AKSettingsManager*)sharedManager;
+(NSString*) settingsFilePath;


-(AKSettingsSortOption) getSortOption;
-(AKSettingsFilterQuotaOption) getQuotaFilter;
-(NSArray*) getStatesFilter;
-(NSArray*) getPartiesFilter;

-(void) setSortOption:(AKSettingsSortOption) sortOption;
-(void) setQuotaFilterOption:(AKSettingsFilterQuotaOption) quotaOption;
-(void) setStatesFilter:(NSArray*) statesFilter;
-(void) setPartiesFilter:(NSArray*) partiesFilter;

-(void) addPartyFilter:(NSString*) partyFilter;
-(void) addStateFilter:(NSString*) stateFilter;
-(void) removePartyFilter:(NSString*) partyFilter;
-(void) removeStateFilter:(NSString*) stateFilter;

-(NSString*) actualSettingsInfoLog;

@end
