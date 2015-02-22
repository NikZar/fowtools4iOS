//
//  Turn+Management.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "Turn+Management.h"
#import "Match.h"
#import "Constants.h"

@implementation Turn (Management)

+(Turn *)newTurnInMOC:(NSManagedObjectContext*)moc
{
    Turn *newTurn = [NSEntityDescription
                       insertNewObjectForEntityForName:@"Turn"
                       inManagedObjectContext:moc];
    newTurn.date = [NSDate new];
    return newTurn;
}

- (NSString *)description
{
    NSString *playerName = @"";
    if([self.activeP1 boolValue]){
        playerName = self.match.nameP1 ? self.match.nameP1 : kP1Name;
    } else {
        playerName = self.match.nameP2 ? self.match.nameP2 : kP2Name;
    }
    return [NSString stringWithFormat:@"Turn #%@: %@", self.number, playerName];
}

@end
