//
//  SyncManager.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 9/19/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "SyncManager.h"
#import "Constants.h"

@implementation SyncManager

+ (id)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

-(void)updateLastSyncForResource:(NSString *)resourceName
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey: [NSString stringWithFormat:@"%@%@", kResourcePrefix, resourceName]];
}

-(NSDate *)lastSyncForResource:(NSString *)resourceName
{
    NSDate *syncDate = [[NSUserDefaults standardUserDefaults] valueForKey: [NSString stringWithFormat:@"%@%@", kResourcePrefix, resourceName]];
    return syncDate ? syncDate : [NSDate distantPast];
}

@end
