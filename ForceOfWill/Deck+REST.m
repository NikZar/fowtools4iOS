//
//  Deck+REST.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/23/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "Deck+REST.h"
#import "DeckCard+REST.h"

@implementation Deck (REST)

- (void)updateWithDeckREST: (DeckREST *)deckREST inManagedObjectContext:(NSManagedObjectContext *)context
{
    self.title = deckREST.title ? deckREST.title : self.title;
    self.privacy = deckREST.privacy ? deckREST.privacy : self.privacy;
    self.notes = deckREST.notes ? deckREST.notes : self.notes;
    self.identifier = deckREST.identifier ? deckREST.identifier : self.identifier;
    self.author = deckREST.author ? deckREST.author : self.author;
    
    [self removeCards:self.cards];
    for (DeckCardREST *deckCardREST in deckREST.cards) {
        DeckCard *deckCard = [NSEntityDescription
                                     insertNewObjectForEntityForName:@"DeckCard"
                                     inManagedObjectContext:context];
        [deckCard updateWithDeckCardREST:deckCardREST inManagedObjectContext:context];
        [self addCardsObject:deckCard];
    }
    
    [self removeSide:self.side];
    for (DeckCardREST *deckCardREST in deckREST.side) {
        DeckCard *deckCard = [NSEntityDescription
                              insertNewObjectForEntityForName:@"DeckCard"
                              inManagedObjectContext:context];
        [deckCard updateWithDeckCardREST:deckCardREST inManagedObjectContext:context];
        [self addSideObject:deckCard];
    }
}

@end
