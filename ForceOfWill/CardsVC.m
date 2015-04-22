//
//  CardsVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/26/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "CardsVC.h"
#import <RestKit/RestKit.h>
#import "Card+REST.h"
#import "AppDelegate.h"
#import "CardCollectionViewCell.h"
#import "CardREST.h"
#import "CardDetailVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface CardsVC ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak,nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UISearchDisplayController *mySearchDisplayController;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

static NSString *CellIdentifier = @"cardSlide";

@implementation CardsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    
    CGSize viewSize = self.view.frame.size;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(2, 0, viewSize.width-82, viewSize.height)];
    self.mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.mySearchDisplayController.delegate = self;
    [self setupNavigationBar];
    [self loadCards];
}


-(void)loadCards
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    //AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
 
    //if(delegate.facebookToken){
        //NSDictionary *queryParams = @{@"token" : delegate.facebookToken};
        
        [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/cards"
                                               parameters:nil
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                      [NSThread detachNewThreadSelector:@selector(syncCards:) toTarget:self withObject:mappingResult.array];
                                                      UIApplication* app = [UIApplication sharedApplication];
                                                      app.networkActivityIndicatorVisible = NO;
                                                      [self syncCards: mappingResult.array];
                                                  }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                      NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                                  }];
    //}
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)syncCards: (NSArray *)cardsREST
{
    
    __block NSManagedObjectContext *mainContext = self.context;
    __block CardsVC *this = self;
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = self.context;
    
    [temporaryContext performBlock:^{
        // do something that takes some time asynchronously using the temp context
        for (CardREST *cardREST in cardsREST) {
            Card *card = [self getCardWithID: cardREST.identifier inManagedObjectContext:temporaryContext];
            if(!card){
                card = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Card"
                        inManagedObjectContext:temporaryContext];
            }
            [card updateWithCardREST:cardREST];
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
            [NSThread detachNewThreadSelector:@selector(loadImages) toTarget:this withObject:nil];
        }];
    }];
}

-(Card *)getCardWithID:(NSString *)identifier inManagedObjectContext: (NSManagedObjectContext *)context
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

-(void)loadImages
{
    __block NSManagedObjectContext *mainContext = self.context;
    
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = self.context;
    
    [temporaryContext performBlock:^{
        // do something that takes some time asynchronously using the temp context
        for (Card * card in [self.fetchedResultsController fetchedObjects]) {
            if(card && !card.image){
                AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                NSString *path = [NSString stringWithFormat:@"%@%@", delegate.baseImageUrlString, card.imageUrl ];
                NSURL *url = [NSURL URLWithString: path];
                UIApplication* app = [UIApplication sharedApplication];
                app.networkActivityIndicatorVisible = YES;
                NSData *data = [NSData dataWithContentsOfURL:url];
                app.networkActivityIndicatorVisible = NO;
                
                card.image = data;
                
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
            } else {
                //NSLog(@"Image already downloaded!");
            }
        }
        
       
    }];
}

#pragma mark - UICollectionVIew

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return self.collectionView.frame.size;
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger sections = [[self.fetchedResultsController sections] count];
    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSInteger rows =[sectionInfo numberOfObjects];
    
    return rows;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.card = (Card *)object;
    
    [cell updateCell];

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"card"]){
        CardDetailVC *cdVC = [segue destinationViewController];
        
        NSIndexPath * selIndexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        cdVC.card = [self.fetchedResultsController objectAtIndexPath:selIndexPath];
        
        [self hideSearchBar];
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
                                   entityForName:@"Card" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"code" ascending:YES];
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

- (void)performFetch
{
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        //TODO: add some logic to handle this error..
        NSLog(@"Unresolved error while retrieving Settings Menu %@, %@", error, [error userInfo]);
        abort();
    }
    [self.collectionView reloadData];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    [self.collectionView reloadData];

}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{

    [self.collectionView reloadData];

}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView reloadData];
}

#pragma mark - Search

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)showSearchBar
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"";
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    UIBarButtonItem *cancelBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(hideSearchBar)];
    self.navigationItem.rightBarButtonItems = @[cancelBarItem, searchBarItem];
    [self.searchBar becomeFirstResponder];
}

- (void)hideSearchBar
{
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.title = @"Cards";
    self.navigationItem.rightBarButtonItems = nil;
    [self setupNavigationBar];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self updateSearchPredicateWithString:searchString];
    return YES;
}

- (void)updateSearchPredicateWithString: (NSString *)searchString
{
    if (!searchString || [searchString isEqualToString:@""]) {
        [self.fetchedResultsController.fetchRequest setPredicate:nil];
    } else {
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchString];
        [self.fetchedResultsController.fetchRequest setPredicate:searchPredicate];
    }
    [self performFetch];
}

#pragma mark - UI Methods

- (void)setupNavigationBar
{
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    searchButton.tintColor = [UIColor blackColor];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(showSearchBar) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
}

@end
