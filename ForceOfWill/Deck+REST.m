//
//  Deck+REST.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/23/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "Deck+REST.h"
#import "DeckCard+REST.h"
#import "Card+REST.h"

@implementation Deck (REST)

- (void)updateWithDeckREST: (DeckREST *)deckREST inManagedObjectContext:(NSManagedObjectContext *)context
{
    self.title = deckREST.title ? deckREST.title : self.title;
    self.privacy = deckREST.privacy ? deckREST.privacy : self.privacy;
    self.notes = deckREST.notes ? deckREST.notes : self.notes;
    self.identifier = deckREST.identifier ? deckREST.identifier : self.identifier;
    self.author = deckREST.author ? deckREST.author : self.author;
    self.lastUpdate = deckREST.lastUpdate ? deckREST.lastUpdate : self.lastUpdate;
    
    for (DeckCard *deckCard in self.cards) {
        [context deleteObject:deckCard];
    }
    [self removeCards:self.cards];
    
    //CARDS
    NSNumber *cardsCount = @0;
    self.cards = [[NSSet alloc] init];
    
    BOOL isWindSet = NO;
    BOOL isDarknessSet = NO;
    BOOL isFireSet = NO;
    BOOL isWaterSet = NO;
    BOOL isLightSet = NO;
    for (DeckCardREST *deckCardREST in deckREST.cards) {
            DeckCard *deckCard = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"DeckCard"
                                  inManagedObjectContext:context];
            [deckCard updateWithDeckCardREST:deckCardREST inManagedObjectContext:context];
            [self addCardsObject:deckCard];
            
            if(!isWindSet){
                if ([deckCard.card.attribute containsString:@"Wind"] || [deckCard.card.attribute containsString:@"wind"]) {
                    self.isWind = [NSNumber numberWithBool:YES];
                    isWindSet = YES;
                }
            }
            if(!isDarknessSet){
                if ([deckCard.card.attribute containsString:@"Dark"] || [deckCard.card.attribute containsString:@"dark"]) {
                    self.isDarkness = [NSNumber numberWithBool:YES];
                    isDarknessSet = YES;
                }
            }
            if(!isFireSet){
                if ([deckCard.card.attribute containsString:@"Fire"] || [deckCard.card.attribute containsString:@"fire"]) {
                    self.isFire = [NSNumber numberWithBool:YES];
                    isFireSet = YES;
                }
            }
            if(!isWaterSet){
                if ([deckCard.card.attribute containsString:@"Water"] || [deckCard.card.attribute containsString:@"water"]) {
                    self.isWater = [NSNumber numberWithBool:YES];
                    isWaterSet = YES;
                }
            }
            if(!isLightSet){
                if ([deckCard.card.attribute containsString:@"Light"] || [deckCard.card.attribute containsString:@"light"]) {
                    self.isLight = [NSNumber numberWithBool:YES];
                    isLightSet = YES;
                }
            }
            
            if([deckCard.card.type isEqualToString:@"Resonator"] || [deckCard.card.type isEqualToString:@"Addition"] || [deckCard.card.type isEqualToString:@"Spell"]){
                cardsCount = [NSNumber numberWithInt: [cardsCount intValue] + [deckCard.qty intValue] ];
            }
    }
    
    if(!isWindSet){
        self.isWind = [NSNumber numberWithBool:NO];
    }
    if(!isDarknessSet){
        self.isDarkness = [NSNumber numberWithBool:NO];
    }
    if(!isFireSet){
        self.isFire = [NSNumber numberWithBool:NO];
    }
    if(!isWaterSet){
        self.isWater = [NSNumber numberWithBool:NO];
    }
    if(!isLightSet){
        self.isLight = [NSNumber numberWithBool:NO];
    }

    self.cardsCount = cardsCount;
    
    
    //SIDE
    for (DeckCard *deckCard in self.side) {
        @autoreleasepool {
            [context deleteObject:deckCard];
        }
    }
    [self removeSide:self.side];
    self.side = [[NSSet alloc] init];
    NSNumber *sideCount = @0;
    for (DeckCardREST *deckCardREST in deckREST.side) {
        @autoreleasepool {
            DeckCard *deckCard = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"DeckCard"
                                  inManagedObjectContext:context];
            [deckCard updateWithDeckCardREST:deckCardREST inManagedObjectContext:context];
            [self addSideObject:deckCard];
            
            sideCount = [NSNumber numberWithInt: [sideCount intValue] + [deckCard.qty intValue] ];
        }
    }
    self.sideCount = sideCount;
    
    if(deckREST.ruler){
        Card *ruler = [Card getCardWithID: deckREST.ruler.identifier inManagedObjectContext:context];
        if(!ruler){
            ruler = [NSEntityDescription
                    insertNewObjectForEntityForName:@"Card"
                    inManagedObjectContext:context];
            [ruler updateWithCardREST:deckREST.ruler];
        }
        self.ruler = ruler ? ruler : self.ruler;
    }
}

@end
