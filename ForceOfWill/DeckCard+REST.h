//
//  DeckCard+REST.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/25/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "DeckCard.h"
#import "DeckCardREST.h"

@interface DeckCard (REST)

- (void)updateWithDeckCardREST: (DeckCardREST *)deckCardREST inManagedObjectContext:(NSManagedObjectContext *)context;

@end
