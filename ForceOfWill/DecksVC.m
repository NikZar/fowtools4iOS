//
//  DecksVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/22/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "DecksVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <RestKit/RestKit.h>
#import "Deck+REST.h"
#import "AppDelegate.h"

@interface DecksVC ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak,nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UISearchDisplayController *mySearchDisplayController;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation DecksVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate * appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    
    [self loadDecks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadDecks
{
    if ([FBSDKAccessToken currentAccessToken]) {
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;

        NSDictionary *queryParams = @{@"token" : [[FBSDKAccessToken currentAccessToken] tokenString]};
        
        [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/decks"
                                               parameters:queryParams
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                      //                                                      [NSThread detachNewThreadSelector:@selector(syncCards:) toTarget:self withObject:mappingResult.array];
                                                      UIApplication* app = [UIApplication sharedApplication];
                                                      app.networkActivityIndicatorVisible = NO;
                                                      [self syncDecks: mappingResult.array];
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                                  }];
    }
    
    
}

- (void)syncDecks: (NSArray *)decksREST
{
    
    __block NSManagedObjectContext *mainContext = self.context;
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = self.context;
    
    [temporaryContext performBlock:^{
        // do something that takes some time asynchronously using the temp context
        for (DeckREST *deckREST in decksREST) {
            Deck *deck = [self getDeckWithID: deckREST.identifier inManagedObjectContext:temporaryContext];
            if(!deck){
                deck = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Deck"
                        inManagedObjectContext:temporaryContext];
            }
            [deck updateWithDeckREST:deckREST];
        }
        
        // push to parent
        NSError *error = nil;
        if (![temporaryContext save:&error])
        {
            NSLog(@"Error in temporaryContext: %@", error.localizedDescription);
        }
        
        // save parent to disk asynchronously
        [mainContext performBlock:^{
            NSError *error;
            if (![mainContext save:&error])
            {
                NSLog(@"Error in mainContext: %@", error.localizedDescription);
            }
        }];
    }];
}

-(Deck *)getDeckWithID:(NSString *)identifier inManagedObjectContext: (NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Deck"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
