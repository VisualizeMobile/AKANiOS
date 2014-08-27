//
//  AKSettingsManager.m
//  AKANiOS
//
//  Created by Matheus Fonseca on 13/08/14.
//  Copyright (c) 2014 VisualizeMobile. All rights reserved.
//

#import "AKSettingsManager.h"

@interface AKSettingsManager () {
    AKSettingsSortOption _sortOption;
    AKSettingsFilterQuotaOption _filterQuotaOption;
    NSMutableArray *_filterStates;
    NSMutableArray *_filterParties;
    NSInteger _dataUpdateVersion;
}

@end

@implementation AKSettingsManager

-(void)saveSettings {
    NSMutableData *settingsData = [NSMutableData data];
    NSKeyedArchiver *aCoder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:settingsData];

    [aCoder encodeInteger:_dataUpdateVersion forKey:@"dataUpdateVersion"];
    [aCoder encodeInteger:_sortOption forKey:@"sortOption"];
    [aCoder encodeInteger:_filterQuotaOption forKey:@"filterQuotaOption"];
    [aCoder encodeObject:_filterStates forKey:@"filterStates"];
    [aCoder encodeObject:_filterParties forKey:@"filterParties"];
    
    [aCoder finishEncoding];
    
    [settingsData writeToFile:[AKSettingsManager settingsFilePath] atomically:YES];
}

-(id) init {
    @throw [NSException exceptionWithName: @"AKSettingsManagerInitException"
                                   reason: @"Method \"-init\" is not allowed, use \"+sharedManager\" instead"
                                 userInfo: nil];
}

-(id) initPrivate {
    self = [super init];
    
    if(self) {
        NSData *settingsData = [[NSData alloc] initWithContentsOfFile:[AKSettingsManager settingsFilePath]];
        NSKeyedUnarchiver *aDecoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:settingsData];
        
        _dataUpdateVersion = [aDecoder decodeIntegerForKey:@"dataUpdateVersion"];
        _sortOption = [aDecoder decodeIntegerForKey:@"sortOption"];
        _filterQuotaOption = [aDecoder decodeIntegerForKey:@"filterQuotaOption"];
        _filterStates = [aDecoder decodeObjectForKey:@"filterStates"];
        _filterParties = [aDecoder decodeObjectForKey:@"filterParties"];
        
        [aDecoder finishDecoding];
        
        if(_filterParties == nil)
            _filterParties = [[NSMutableArray alloc] init];
        
        if(_filterStates == nil)
            _filterStates = [[NSMutableArray alloc] init];
    }
    
    return self;

}

+ (AKSettingsManager*)sharedManager {
    static AKSettingsManager *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] initPrivate];
//        sharedMyManager = [[self alloc] init];;
    });
    
    return sharedMyManager;
}

+(NSString*) settingsFilePath {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [NSString stringWithFormat:@"%@/akan_settings.plist", documentsPath];
}

-(NSInteger) getDataUpdateVersion {
    return _dataUpdateVersion;
}

-(AKSettingsSortOption) getSortOption {
    return _sortOption;
}

-(AKSettingsFilterQuotaOption) getQuotaFilter {
    return _filterQuotaOption;
}

-(NSArray*) getStatesFilter {
    return _filterStates;
}

-(NSArray*) getPartiesFilter {
    return _filterParties;
}


-(void) setDataUpdateVersion:(NSInteger)dataUpdateVersion {
    _dataUpdateVersion = dataUpdateVersion;
    [self saveSettings];
}

-(void) setSortOption:(AKSettingsSortOption) sortOption {
    _sortOption = sortOption;
    [self saveSettings];
}

-(void) setQuotaFilterOption:(AKSettingsFilterQuotaOption) quotaOption {
    _filterQuotaOption = quotaOption;
    [self saveSettings];
}

-(void) setQuotaFilter:(AKSettingsFilterQuotaOption) quotaFilter {
    _filterQuotaOption = quotaFilter;
    [self saveSettings];
}

-(void) setStatesFilter:(NSArray*) statesFilter {
    _filterStates = [[NSMutableArray alloc] initWithArray: statesFilter];
    [self saveSettings];
}

-(void) setPartiesFilter:(NSArray*) partiesFilter {
    _filterParties = [[NSMutableArray alloc] initWithArray: partiesFilter];
    [self saveSettings];
}

-(void) addPartyFilter:(NSString*) partyFilter {
    [_filterParties addObject:partyFilter];
    
    [self saveSettings];
}

-(void) addStateFilter:(NSString*) stateFilter {
    [_filterStates addObject:stateFilter];
    
    [self saveSettings];
}

-(void) removePartyFilter:(NSString*) partyFilter {
    if ([_filterParties containsObject:partyFilter])
        [_filterParties removeObject:partyFilter];
    
    [self saveSettings];
}

-(void) removeStateFilter:(NSString*) stateFilter {
    if ([_filterStates containsObject:stateFilter])
        [_filterStates removeObject:stateFilter];
    
    [self saveSettings];
}

-(NSString*) actualSettingsInfoLog {
    
    return [NSString stringWithFormat: @"{\n\tData version = %ld \n\tSort option = %d \n\tQuota filter = %d \n\tStates filter = %@ \n\tParties filter = %@\n}", _dataUpdateVersion, _sortOption, _filterQuotaOption, (NSArray*)_filterStates, (NSArray*)_filterParties];
    
}

@end
