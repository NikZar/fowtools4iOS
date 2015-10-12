//
//  SyncManager.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 9/19/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Manager.h"

@interface SyncManager : NSObject

+ (id)sharedManager;

- (NSDate *)lastSyncForResource:(NSString *)resourceName;

- (void)updateLastSyncForResource:(NSString *)resourceName;

@end
