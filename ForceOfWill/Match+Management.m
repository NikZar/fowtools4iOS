//
//  Match+Management.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "Match+Management.h"
#import "Constants.h"
#import "Turn.h"
#import "LifeChange.h"

@implementation Match (Management)

+ (Match *)newMatchInMOC:(NSManagedObjectContext*)moc
{
    Match *newMatch = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Match"
                                    inManagedObjectContext:moc];
    newMatch.date = [NSDate new];
    return newMatch;
}

+ (Match *)latestMatchInMOC:(NSManagedObjectContext*)moc
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Match"];
    
    NSSortDescriptor *dateSD = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:@[dateSD]];
    //fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];
    
    return [results firstObject];
}

- (NSNumber *)currentLifePointsForPlayer:(FOWPlayer)player
{
    NSSortDescriptor * dateSD = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:false];
    NSArray * sortedTurns = [self.turns sortedArrayUsingDescriptors:@[dateSD]];
    
    if([sortedTurns count]>0){
        for (int i = 0; i < sortedTurns.count; i++) {
            
            Turn *latestTurn = (Turn *)[sortedTurns objectAtIndex:i];
            BOOL isPlayer1 = player == FOWPlayer1;
            NSSet * lifeChanges = [latestTurn.lifeChanges filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"aboutP1==%@", [NSNumber numberWithBool:isPlayer1]]];
            
            if([lifeChanges count]>0){
                NSArray * sortedLifeChanges = [lifeChanges sortedArrayUsingDescriptors:@[dateSD]];
                LifeChange * latestLifeChange = [sortedLifeChanges firstObject];
                return latestLifeChange.lifePoints;
            }
            
        }
    }
    
    return kFOWStartLifePoints;
}

@end
