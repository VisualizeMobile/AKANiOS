//
//  AKSettingsManager.h
//  AKANiOS
//
//  Created by Matheus Fonseca on 13/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(char, AKSettingsSortOption) {
    AKSettingsSortOptionRanking, AKSettingsSortOptionAlphabetic,
    AKSettingsSortOptionParty, AKSettingsSortOptionState
};

typedef NS_ENUM(char, AKSettingsFilterQuotaOption) {
    AKSettingsFilterQuotaOptionNone, AKSettingsFilterQuotaOption10,
    AKSettingsFilterQuotaOption30, AKSettingsFilterQuotaOption50,
    AKSettingsFilterQuotaOption100, AKSettingsFilterQuotaOption150,
    AKSettingsFilterQuotaOption200, AKSettingsFilterQuotaOption300
};

@interface AKSettingsManager : NSObject

+(AKSettingsManager*)sharedManager;
+(NSString*) settingsFilePath;

-(NSInteger) getDataUpdateVersion;
-(AKSettingsSortOption) getSortOption;
-(AKSettingsFilterQuotaOption) getQuotaFilter;
-(NSArray*) getStatesFilter;
-(NSArray*) getPartiesFilter;

-(void) setDataUpdateVersion:(NSInteger)dataUpdateVersion;
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
