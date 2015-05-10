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
    
    for (DeckCard *deckCard in self.cards) {
        [context deleteObject:deckCard];
    }
    [self removeCards:self.cards];
    
    //CARDS
    NSNumber *cardsCount = @0;
    self.cards = [[NSSet alloc] init];
    for (DeckCardREST *deckCardREST in deckREST.cards) {
        DeckCard *deckCard = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"DeckCard"
                                     inManagedObjectContext:context];
        [deckCard updateWithDeckCardREST:deckCardREST inManagedObjectContext:context];
        [self addCardsObject:deckCard];
        
        if([deckCard.card.type isEqualToString:@"Resonator"] || [deckCard.card.type isEqualToString:@"Addition"] || [deckCard.card.type isEqualToString:@"Spell"]){
            cardsCount = [NSNumber numberWithInt: [cardsCount intValue] + [deckCard.qty intValue] ];
        }
    }
    self.cardsCount = cardsCount;
    
    
    //SIDE
    for (DeckCard *deckCard in self.side) {
        [context deleteObject:deckCard];
    }
    [self removeSide:self.side];
    self.side = [[NSSet alloc] init];
    NSNumber *sideCount = @0;
    for (DeckCardREST *deckCardREST in deckREST.side) {
        DeckCard *deckCard = [NSEntityDescription
                              insertNewObjectForEntityForName:@"DeckCard"
                              inManagedObjectContext:context];
        [deckCard updateWithDeckCardREST:deckCardREST inManagedObjectContext:context];
        [self addSideObject:deckCard];
        
        sideCount = [NSNumber numberWithInt: [sideCount intValue] + [deckCard.qty intValue] ];
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
