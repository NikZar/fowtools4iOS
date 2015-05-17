//
//  DecksTVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/24/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "DecksTVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <RestKit/RestKit.h>
#import "Deck+REST.h"
#import "AppDelegate.h"
#import "DeckTVCell.h"
#import "DeckTVC.h"

@interface DecksTVC ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak,nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UISearchDisplayController *mySearchDisplayController;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

@implementation DecksTVC

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

    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;

    NSDictionary *queryParams = nil;
    if ([FBSDKAccessToken currentAccessToken]) {
        queryParams = @{@"token" : [[FBSDKAccessToken currentAccessToken] tokenString]};
    }
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/decks"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  //                                                      [NSThread detachNewThreadSelector:@selector(syncCards:) toTarget:self withObject:mappingResult.array];
                                                  [self syncDecks: mappingResult.array];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];

    
    
}

- (void)syncDecks: (NSArray *)decksREST
{
    
    __block NSManagedObjectContext *mainContext = self.context;
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = self.context;
    
    [temporaryContext performBlock:^{
        // do something that takes some time asynchronously using the temp context
        for (DeckREST *deckREST in decksREST) {
            if([deckREST.cards count] >= 1){
                
                Deck *deck = [self getDeckWithID: deckREST.identifier inManagedObjectContext:temporaryContext];
                if(!deck){
                    deck = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Deck"
                            inManagedObjectContext:temporaryContext];
                }
                [deck updateWithDeckREST:deckREST inManagedObjectContext: temporaryContext];
                                
                // push to parent
                NSError *error = nil;
                if (![temporaryContext save:&error])
                {
                    NSLog(@"Error in temporaryContext: %@", error.localizedDescription);
                }
            }
        }
        
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = [[self.fetchedResultsController sections] count];
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSInteger rows =[sectionInfo numberOfObjects];
    
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeckTVCell *cell = (DeckTVCell *)[tableView dequeueReusableCellWithIdentifier:@"deckCell" forIndexPath:indexPath];
    cell.context = self.context;
    cell.deck = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell updateCell];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //     Get the new view controller using [segue destinationViewController].
    //     Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"deckDetail"]){
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        DeckTVC *destinationViewController = (DeckTVC *)[segue destinationViewController];
        destinationViewController.context = self.context;
        destinationViewController.deck = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
    }
}


#pragma mark - FRC Delegate

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSManagedObjectContext * managedObjectContext = self.context;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Deck" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *minimumCardsPredicate = [NSPredicate predicateWithFormat:@"cardsCount >= 40"];
    
    [fetchRequest setPredicate:minimumCardsPredicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"lastUpdate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:nil];
    _fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        //TODO: add some logic to handle this error..
        NSLog(@"Unresolved error while retrieving Settings Menu %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    [self.tableView reloadData];
    
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    [self.tableView reloadData];
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}



@end
