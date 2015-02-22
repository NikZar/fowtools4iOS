//
//  Turn+Management.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "Turn.h"

@interface Turn (Management)

+ (Turn *)newTurnInMOC:(NSManagedObjectContext*)moc;

- (NSString *)description;

@end
