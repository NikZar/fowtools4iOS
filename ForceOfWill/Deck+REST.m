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
#import "AppDelegate.h"
#import "SyncManager.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <RestKit/RestKit.h>

#define DECK_RESOURCE_NAME @"Deck"

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

+(Deck *)getDeckWithID:(NSString *)identifier inManagedObjectContext: (NSManagedObjectContext *)context
{
    @autoreleasepool {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:DECK_RESOURCE_NAME];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier LIKE %@", identifier];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setFetchLimit:1];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
        
        if (!results || ([results count] == 0)) {
            return nil;
        } else {
            return [results firstObject];
        }
    }
}

+(void)syncDecks
{
    NSDate *lastUpdate = [[SyncManager sharedManager] lastSyncForResource:DECK_RESOURCE_NAME];
    if([lastUpdate timeIntervalSinceNow] < -3000)
    {
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        
        NSDictionary *queryParams = nil;
        if ([FBSDKAccessToken currentAccessToken]) {
            queryParams = @{@"token" : [[FBSDKAccessToken currentAccessToken] tokenString]};
        }
        [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/decks"
                                               parameters:queryParams
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      [self updateDecks: mappingResult.array];
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      NSLog(@"Restkit error': %@", error);
                                                  }];
    }
}

+ (void)updateDecks: (NSArray *)decksREST
{
    [[SyncManager sharedManager] updateLastSyncForResource:DECK_RESOURCE_NAME];
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [delegate managedObjectContext];
    
    __block NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = mainContext;
    
    [temporaryContext performBlock:^{
        // do something that takes some time asynchronously using the temp context
        int i = 0;
        for (DeckREST *deckREST in decksREST) {
            @autoreleasepool {
                if([deckREST.cards count] >= 1){
                    
                    Deck *deck = [self getDeckWithID: deckREST.identifier inManagedObjectContext:temporaryContext];
                    if(!deck){
                        deck = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Deck"
                                inManagedObjectContext:temporaryContext];
                    }
                    [deck updateWithDeckREST:deckREST inManagedObjectContext: temporaryContext];
                    
                    i++;
                }
            }
        }
        
        // push to parent
        NSError *error = nil;
        if (![temporaryContext save:&error])
        {
            NSLog(@"Error in temporaryContext: %@", error.localizedDescription);
        }
        
        for (NSManagedObject * deck in [temporaryContext registeredObjects]) {
            [temporaryContext refreshObject:deck mergeChanges:NO];
        }
        [temporaryContext reset];
        
        // save parent to disk asynchronously
        [mainContext performBlock:^{
            NSError *error;
            if (![mainContext save:&error])
            {
                NSLog(@"Error in mainContext: %@", error.localizedDescription);
            }
        }];
        
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = NO;
    }];
}



@end
