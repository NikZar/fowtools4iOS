//
//  Deck+REST.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/23/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "Deck.h"
#import "DeckREST.h"

@interface Deck (REST)

- (void)updateWithDeckREST: (DeckREST *)deckREST inManagedObjectContext:(NSManagedObjectContext *)context;

@end
