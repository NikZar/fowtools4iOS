//
//  Match.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/28/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Turn;

@interface Match : NSManagedObject

@property (nonatomic, retain) NSString * nameP1;
@property (nonatomic, retain) NSString * nameP2;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *turns;
@end

@interface Match (CoreDataGeneratedAccessors)

- (void)addTurnsObject:(Turn *)value;
- (void)removeTurnsObject:(Turn *)value;
- (void)addTurns:(NSSet *)values;
- (void)removeTurns:(NSSet *)values;

@end
