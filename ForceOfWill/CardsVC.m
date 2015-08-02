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
#import "FiltersTVC.h"
#import "Constants.h"

@interface CardsVC ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UISearchDisplayController *mySearchDisplayController;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

static NSString *CellIdentifier = @"cardSlide";

@implementation CardsVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self resetFilters];
    
    AppDelegate * appDelegate =(AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.context = appDelegate.managedObjectContext;
    
    CGSize viewSize = self.view.frame.size;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(2, 0, viewSize.width-82, viewSize.height)];
    self.mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.mySearchDisplayController.delegate = self;
    [self setupNavigationBar];
    [self loadCards];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self updateFilterPredicate];
}

-(void)resetFilters
{
    self.filters = [    @[
                          [@{@"title": @"name", @"type": kTextFilter, @"value":@""} mutableCopy],
                          [@{@"title": @"text", @"type": kTextFilter, @"value":@""} mutableCopy],
                          [@{@"title": @"subtype", @"type": kTextFilter, @"value":@""} mutableCopy],
                          [@{@"title": @"race", @"type": kTextFilter, @"value":@""} mutableCopy],
                          [@{@"title": @"attribute", @"type": kSegmentedFilter, @"value":@"All", @"options":@[@"All", @"Light",@"Dark",@"Wind",@"Fire",@"Water"]} mutableCopy],
                          [@{@"title": @"type", @"type": kSegmentedFilter, @"value":@"All", @"options":@[@"All", @"Ruler",@"Resonator",@"Spell",@"Addition",@"Regalia",@"Stone"]} mutableCopy],
                          [@{@"title": @"expansionS", @"type": kSegmentedFilter, @"value":@"All", @"options":@[@"All", @"Dual Deck Faria vs Melgis"]} mutableCopy],
                          [@{@"title": @"expansionS", @"type": kSegmentedFilter, @"value":@"All", @"options":@[@"All", @"Vingolf 01", @"The Millennia of Ages", @"The Moon Princess Returns",@"The Castle of Heaven and The Two Tower",@"The Crimson Moon Fairy Tale"]} mutableCopy],
                          [@{@"title": @"expansionS", @"type": kSegmentedFilter, @"value":@"All", @"options":@[@"All", @"The Shaft of Light of Valhalla",@"War of Valhalla",@"Dawn of Valhalla"]} mutableCopy],
                          [@{@"title": @"min cost", @"type": kSliderFilter, @"value":@0, @"min":@0, @"max":@20, @"scale":@1} mutableCopy],
                          [@{@"title": @"max cost", @"type": kSliderFilter, @"value":@20, @"min":@0, @"max":@20,@"scale":@1} mutableCopy],
                          [@{@"title": @"min atk", @"type": kSliderFilter, @"value":@0, @"min":@0, @"max":@100,@"scale":@100} mutableCopy],
                          [@{@"title": @"max atk", @"type": kSliderFilter, @"value":@100, @"min":@0, @"max":@100, @"scale":@100} mutableCopy],
                          [@{@"title": @"min def", @"type": kSliderFilter, @"value":@0, @"min":@0, @"max":@100, @"scale":@100} mutableCopy],
                          [@{@"title": @"max def", @"type": kSliderFilter, @"value":@100, @"min":@0, @"max":@100, @"scale":@100} mutableCopy]
                          ]
                    mutableCopy];
}

-(void)loadCards
{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    //AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
 
    //if(delegate.facebookToken){
        //NSDictionary *queryParams = @{@"token" : delegate.facebookToken};
    
    __block CardsVC *blockSelf = self;
        
        [[RKObjectManager sharedManager] getObjectsAtPath:@"/api/cards"
                                               parameters:nil
                                                  success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                                      [NSThread detachNewThreadSelector:@selector(syncCards:) toTarget:self withObject:mappingResult.array];
                                                      UIApplication* app = [UIApplication sharedApplication];
                                                      app.networkActivityIndicatorVisible = NO;
                                                      [blockSelf syncCards: mappingResult.array];
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
    
    __block CardsVC *blockSelf = self;
    __block NSManagedObjectContext *mainContext = blockSelf.context;
    __block NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = blockSelf.context;
    
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
            //[NSThread detachNewThreadSelector:@selector(loadImages) toTarget:blockSelf withObject:nil];
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
    __block CardsVC *blockSelf = self;
    __block NSManagedObjectContext *mainContext = blockSelf.context;
    __block NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = blockSelf.context;
    
    [temporaryContext performBlock:^{
        // do something that takes some time asynchronously using the temp context
        for (Card * card in [blockSelf.fetchedResultsController fetchedObjects]) {
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

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViews sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return self.collectionView.frame.size;
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    [collectionView.collectionViewLayout invalidateLayout];

    NSInteger sections = [[self.fetchedResultsController sections] count];
    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [collectionView.collectionViewLayout invalidateLayout];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    NSInteger rows =[sectionInfo numberOfObjects];
    
    return rows;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView.collectionViewLayout invalidateLayout];

    CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.card = (Card *)object;
    cell.context = self.context;
    
    [cell updateCell];

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"card"]){
        CardDetailVC *cdVC = [segue destinationViewController];
        
        NSIndexPath * selIndexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
        cdVC.context = self.context;
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
    
    NSSortDescriptor *sortSet = [[NSSortDescriptor alloc]
                              initWithKey:@"set" ascending:NO];
    NSSortDescriptor *sortNum = [[NSSortDescriptor alloc]
                                 initWithKey:@"num" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortSet, sortNum, nil]];
    
    [fetchRequest setFetchBatchSize:20];
    
//    NSPredicate * filtersPredicate;
//    
//    for (NSDictionary *filter in self.filters) {
//        NSString *type = filter[@"type"];
//        NSPredicate * filterPredicate;
//        
//        if([type isEqualToString:kTextFilter]){
//            NSString * attribute = (NSString *)filter[@"title"];
//            NSString * value = (NSString *)filter[@"value"];
//            if(value && ![value isEqualToString:@""]){
//                filterPredicate = [NSPredicate predicateWithFormat:@"%@ like '%@'", attribute, value];
//            }
//        }
//
//        if(filtersPredicate && filterPredicate){
//            filtersPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[filtersPredicate, filterPredicate]];
//        } else if (filterPredicate){
//            filtersPredicate = filterPredicate;
//        }
//    }
//    if(filtersPredicate){
//        [fetchRequest setPredicate:filtersPredicate];
//    }
    
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

#pragma mark - Filters
- (void)openFilters
{
    FiltersTVC * filtersTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"filters"];
    filtersTVC.cardsVC = self;
    
    [self.navigationController pushViewController:filtersTVC animated:YES];
}

- (void)updateFilterPredicate
{
    NSPredicate * filtersPredicate;
    
    for (NSDictionary *filter in self.filters) {
        NSString *type = filter[@"type"];
        NSPredicate * filterPredicate;
        
        if([type isEqualToString:kTextFilter]){
            NSString * attribute = (NSString *)filter[@"title"];
            NSString * value = (NSString *)filter[@"value"];
            if(value && ![value isEqualToString:@""]){
                filterPredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", attribute, value];
            }
        }
        
        if([type isEqualToString:kSegmentedFilter]){
            NSString * attribute = (NSString *)filter[@"title"];
            NSString * value = (NSString *)filter[@"value"];
            if(value && ![value isEqualToString:@""]  && ![value isEqualToString:@"All"]){
                
                filterPredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", attribute, value];
            }
        }
        
        if(filtersPredicate && filterPredicate){
            filtersPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[filtersPredicate, filterPredicate]];
        } else if (filterPredicate){
            filtersPredicate = filterPredicate;
        }
    }
    NSString * check = [filtersPredicate predicateFormat];

    [self.fetchedResultsController.fetchRequest setPredicate:filtersPredicate];
   
    [self performFetch];
}

#pragma mark - UI Methods

- (void)setupNavigationBar
{
    //search
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 25, 25)];
    searchButton.tintColor = [UIColor blackColor];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(showSearchBar) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 10, 25, 20)];
    filterButton.tintColor = [UIColor blackColor];
    [filterButton setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(openFilters) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:filterButton],[[UIBarButtonItem alloc] initWithCustomView:searchButton]];
}

@end
