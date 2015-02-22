//
//  MatchManager.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Match.h"
#import "Enums.h"

@interface MatchManager : NSObject

@property (strong, nonatomic) NSNumber *player1LP;
@property (strong, nonatomic) NSNumber *player2LP;

@property (strong, nonatomic) NSString *player1Name;
@property (strong, nonatomic) NSString *player2Name;

@property (strong, readonly, nonatomic) Match *currentMatch;
@property (strong, readonly, nonatomic) Turn *currentTurn;

@property (strong, nonatomic) NSManagedObjectContext *moc;

+ (id)sharedMatchManager;

- (void)newTurnForPlayer:(FOWPlayer)player;

- (void)endMatch;

@end
