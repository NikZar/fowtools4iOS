//
//  Deck.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 5/10/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card, DeckCard;

@interface Deck : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * privacy;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * cardsCount;
@property (nonatomic, retain) NSNumber * sideCount;
@property (nonatomic, retain) NSSet *cards;
@property (nonatomic, retain) Card *ruler;
@property (nonatomic, retain) NSSet *side;
@end

@interface Deck (CoreDataGeneratedAccessors)

- (void)addCardsObject:(DeckCard *)value;
- (void)removeCardsObject:(DeckCard *)value;
- (void)addCards:(NSSet *)values;
- (void)removeCards:(NSSet *)values;

- (void)addSideObject:(DeckCard *)value;
- (void)removeSideObject:(DeckCard *)value;
- (void)addSide:(NSSet *)values;
- (void)removeSide:(NSSet *)values;

@end
