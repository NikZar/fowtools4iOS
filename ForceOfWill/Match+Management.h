//
//  Match+Management.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "Match.h"
#import "Enums.h"

@interface Match (Management)

+ (Match *)newMatchInMOC:(NSManagedObjectContext*)moc;
+ (Match *)latestMatchInMOC:(NSManagedObjectContext*)moc;

- (NSNumber *)currentLifePointsForPlayer:(FOWPlayer)player;

@end
