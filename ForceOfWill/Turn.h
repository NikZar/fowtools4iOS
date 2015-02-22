//
//  Turn.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/28/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LifeChange, Match;

@interface Turn : NSManagedObject

@property (nonatomic, retain) NSNumber * activeP1;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) Match *match;
@property (nonatomic, retain) NSSet *lifeChanges;
@end

@interface Turn (CoreDataGeneratedAccessors)

- (void)addLifeChangesObject:(LifeChange *)value;
- (void)removeLifeChangesObject:(LifeChange *)value;
- (void)addLifeChanges:(NSSet *)values;
- (void)removeLifeChanges:(NSSet *)values;

@end
