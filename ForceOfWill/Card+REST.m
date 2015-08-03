//
//  Card+REST.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/1/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "Card+REST.h"
#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import "Constants.h"

@implementation Card (REST)

- (void)updateWithCardREST: (CardREST *)cardREST{
    self.code = cardREST.code ? cardREST.code : self.code;
    self.name = cardREST.name ? cardREST.name : self.name;
    self.imageUrl = cardREST.imageUrl ? cardREST.imageUrl : self.imageUrl;
    self.identifier = cardREST.identifier ? cardREST.identifier : self.identifier;
    self.text = cardREST.text ? cardREST.text : self.text;
    self.type = cardREST.type ? cardREST.type : self.type;
    self.subtype = cardREST.subtype ? cardREST.subtype : self.subtype;
    self.race = cardREST.race ? cardREST.race : self.race;
    self.atk = cardREST.atk ? cardREST.atk : self.atk;
    self.def = cardREST.def ? cardREST.def : self.def;
    self.expansionS = cardREST.expansionS ? cardREST.expansionS : self.expansionS;
    self.attribute = cardREST.attribute ? cardREST.attribute : self.attribute;
    self.set = cardREST.set ? cardREST.set : self.set;
    self.num = cardREST.num ? cardREST.num : self.num;
    self.totalCost = cardREST.totalCost ? cardREST.totalCost : self.totalCost;
}

+ (Card *)getCardWithID:(NSString *)identifier inManagedObjectContext: (NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Card"];
    
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

+ (void)syncCards
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/cards"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  UIApplication* app = [UIApplication sharedApplication];
                                                  app.networkActivityIndicatorVisible = NO;
                                                  [Card updateCards: mappingResult.array];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Restkit error: %@", error);
                                              }];
    
}

+ (void)updateCards: (NSArray *)cardsREST
{
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [delegate managedObjectContext];
    
    __block NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = mainContext;
    
    [temporaryContext performBlock:^{
        // do something that takes some time asynchronously using the temp context
        for (CardREST *cardREST in cardsREST) {
            @autoreleasepool {
                Card *card = [Card getCardWithID: cardREST.identifier inManagedObjectContext:temporaryContext];
                if(!card){
                    card = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Card"
                            inManagedObjectContext:temporaryContext];
                }
                [card updateWithCardREST:cardREST];
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
            if([[NSUserDefaults standardUserDefaults] boolForKey:kDownloadCardsPreference])
            {
                [Card downloadAllImages];
            }
        }];
    }];
}

+ (void)downloadAllImages
{
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *mainContext = [delegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Card" inManagedObjectContext:mainContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortSet = [[NSSortDescriptor alloc]
                                 initWithKey:@"set" ascending:NO];
    NSSortDescriptor *sortNum = [[NSSortDescriptor alloc]
                                 initWithKey:@"num" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortSet, sortNum, nil]];
    
    NSError *error = nil;
    __block NSArray *cards = [mainContext executeFetchRequest:fetchRequest error:&error];
    
    if (!error) {
        __block NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        temporaryContext.parentContext = mainContext;
        
        [temporaryContext performBlock:^{
            // do something that takes some time asynchronously using the temp context
            for (Card * card in cards) {
                @autoreleasepool {
                    if(card && !card.image){
                        
                        NSString *path = [NSString stringWithFormat:@"%@%@", delegate.baseImageUrlString, card.imageUrl ];
                        NSURL *url = [NSURL URLWithString: path];
                        UIApplication* app = [UIApplication sharedApplication];
                        app.networkActivityIndicatorVisible = YES;
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        app.networkActivityIndicatorVisible = NO;
                        
                        card.image = data;
                        
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
                else
                {
                    NSLog(@"Card Image Download Finished!");
                }
            }];
        }];
    }
    
    
}

@end
