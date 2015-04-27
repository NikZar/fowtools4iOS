//
//  DeckCard+REST.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/25/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "DeckCard+REST.h"
#import "Card+REST.h"

@implementation DeckCard (REST)

-(void)updateWithDeckCardREST:(DeckCardREST *)deckCardREST inManagedObjectContext:(NSManagedObjectContext *)context
{
    self.qty = deckCardREST.qty ? deckCardREST.qty : self.qty;
    
    Card *card = [Card getCardWithID: deckCardREST.card.identifier inManagedObjectContext:context];
    if(!card){
        card = [NSEntityDescription
                insertNewObjectForEntityForName:@"Card"
                inManagedObjectContext:context];
        [card updateWithCardREST:deckCardREST.card];
    }
    self.card = card ? card : self.card;
}

@end
