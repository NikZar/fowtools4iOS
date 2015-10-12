//
//  CardsVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/26/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "CardsCVC.h"
#import <RestKit/RestKit.h>
#import "Card+REST.h"
#import "AppDelegate.h"
#import "CardCollectionViewCell.h"
#import "CardREST.h"
#import "CardDetailVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FiltersTVC.h"
#import "Constants.h"

@interface CardsCVC ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) UISearchDisplayController *mySearchDisplayController;
@property (strong, nonatomic) UISearchBar *searchBar;

//Optimized FRC
@property NSMutableArray *sectionChanges;
@property NSMutableArray *itemChanges;

@end

static NSString *CellIdentifier = @"cardSlide";
static NSString *CellLoadingIdentifier = @"cardLoadingSlide";

@implementation CardsCVC

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
    
    [Card syncCards];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self registerNotifications];
    if(self.searchBar.text == nil || [@"" isEqualToString:self.searchBar.text]){
        [self updateFilterPredicate];
    }
    NSLog(@"Top: %f", self.collectionView.contentInset.top);

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self unregisterNotifications];
    [super viewWillDisappear:animated];
}

#pragma mark - Keyboard Handling

-(void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)unregisterNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
}

- (void) keyboardWillHide:(NSNotification *)notification {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVer >= 9) {
        self.collectionView.contentInset = UIEdgeInsetsMake(-120, 0, 0, 0);
    }
}

#pragma mark - Filters

-(void)resetFilters
{
    self.filters = [    @[
                          [@{@"title": @"name",
                             @"attributeName": @"name",
                             @"type": kTextFilter,
                             @"value":@""} mutableCopy],
                          
                          [@{@"title": @"text",
                             @"attributeName": @"text",
                             @"type": kTextFilter,
                             @"value":@""} mutableCopy],
                          
                          [@{@"title": @"subtype",
                             @"attributeName": @"subtype",
                             @"type": kTextFilter,
                             @"value":@""} mutableCopy],
                          
                          [@{@"title": @"race",
                             @"attributeName": @"race",
                             @"type": kTextFilter,
                             @"value":@""} mutableCopy],
                          
                          [@{@"title": @"attribute",
                             @"attributeName": @"attribute",
                             @"type": kSegmentedFilter,
                             @"value":@"All",
                             @"options":@[@"All",
                                          @"Light",
                                          @"Dark",
                                          @"Wind",
                                          @"Fire",
                                          @"Water"]} mutableCopy],
                          
                          [@{@"title": @"type",
                             @"attributeName": @"type",
                             @"type": kSegmentedFilter,
                             @"value":@"All",
                             @"options":@[@"All",
                                          @"Ruler",
                                          @"Resonator",
                                          @"Spell",
                                          @"Addition",
                                          @"Regalia",
                                          @"Stone"]} mutableCopy],
                          
                          [@{@"title": @"Expansion",
                             @"attributeName": @"expansionS",
                             @"type": kSegmentedFilter,
                             @"value":@"All",
                             @"options":@[@"All",
                                          @"Dual Deck Faria vs Melgis",
                                          @"The Seven Kings of the Lands",
                                          @"The Twilight Wanderer"]} mutableCopy],
                          
                          [@{@"title": @"Expansion",
                             @"attributeName": @"expansionS",
                             @"type": kSegmentedFilter,
                             @"value":@"All",
                             @"options":@[@"All",
                                          @"Vingolf 01",
                                          @"The Millennia of Ages",
                                          @"The Moon Princess Returns",
                                          @"The Castle of Heaven and The Two Tower",
                                          @"The Crimson Moon Fairy Tale"]} mutableCopy],
                          
                          [@{@"title": @"Expansion",
                             @"attributeName": @"expansionS",
                             @"type": kSegmentedFilter,
                             @"value":@"All",
                             @"options":@[@"All",
                                          @"The Shaft of Light of Valhalla",
                                          @"War of Valhalla",
                                          @"Dawn of Valhalla"]} mutableCopy],
                          
                          [@{@"title": @"Min cost",
                             @"attributeName": @"totalCost",
                             @"type": kSliderFilter,
                             @"comparison":@">=",
                             @"value":@0,
                             @"min":@0,
                             @"max":@20,
                             @"scale":@1} mutableCopy],
                          
                          [@{@"title": @"Max cost",
                             @"attributeName": @"totalCost",
                             @"type": kSliderFilter,
                             @"comparison":@"<=",
                             @"value":@20,
                             @"min":@0,
                             @"max":@20,
                             @"scale":@1} mutableCopy],
                          
                          [@{@"title": @"min atk",
                             @"attributeName": @"atk",
                             @"type": kSliderFilter,
                             @"comparison":@">=",
                             @"value":@0,
                             @"min":@0,
                             @"max":@100,
                             @"scale":@100} mutableCopy],
                          
                          [@{@"title": @"max atk",
                             @"type": kSliderFilter,
                             @"attributeName": @"atk",
                             @"comparison":@"<=",
                             @"value":@100,
                             @"min":@0,
                             @"max":@100,
                             @"scale":@100} mutableCopy],
                          
                          [@{@"title": @"min def",
                             @"attributeName": @"def",
                             @"type": kSliderFilter,
                             @"comparison":@">=",
                             @"value":@0,
                             @"min":@0,
                             @"max":@100,
                             @"scale":@100} mutableCopy],
                          
                          [@{@"title": @"max def",
                             @"attributeName": @"def",
                             @"type": kSliderFilter,
                             @"comparison":@"<=",
                             @"value":@100,
                             @"min":@0,
                             @"max":@100,
                             @"scale":@100} mutableCopy]
                          ]
                    mutableCopy];
}


#pragma mark - UICollectionVIew

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViews sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
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
    
    if(rows <= 0){
        return 1;
    }
    
    return rows;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[self.fetchedResultsController fetchedObjects] count] == 0){
        return [collectionView dequeueReusableCellWithReuseIdentifier:CellLoadingIdentifier forIndexPath:indexPath];
    }

    CardCollectionViewCell *cell = (CardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Card * card = (Card *)object;
    cell.card = card;
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
    [self.collectionView invalidateIntrinsicContentSize];

}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    _sectionChanges = [[NSMutableArray alloc] init];
    _itemChanges = [[NSMutableArray alloc] init];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    change[@(type)] = @(sectionIndex);
    [_sectionChanges addObject:change];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    NSMutableDictionary *change = [[NSMutableDictionary alloc] init];
    switch(type) {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_itemChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView performBatchUpdates:^{
        for (NSDictionary *change in _sectionChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:[obj unsignedIntegerValue]]];
                        break;
                    default:
                        break;
                }
            }];
        }
        for (NSDictionary *change in _itemChanges) {
            [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                switch(type) {
                    case NSFetchedResultsChangeInsert:
                        [self.collectionView insertItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeDelete:
                        [self.collectionView deleteItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeUpdate:
                        [self.collectionView reloadItemsAtIndexPaths:@[obj]];
                        break;
                    case NSFetchedResultsChangeMove:
                        [self.collectionView moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                        break;
                }
            }];
        }
    } completion:^(BOOL finished) {
        _sectionChanges = nil;
        _itemChanges = nil;
    }];
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
    self.searchBar.text = @"";
    
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
            NSString * attribute = (NSString *)filter[@"attributeName"];
            NSString * value = (NSString *)filter[@"value"];
            if(value && ![value isEqualToString:@""]){
                filterPredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", attribute, value];
            }
        }
        
        if([type isEqualToString:kSegmentedFilter]){
            NSString * attribute = (NSString *)filter[@"attributeName"];
            NSString * value = (NSString *)filter[@"value"];
            if(value && ![value isEqualToString:@""]  && ![value isEqualToString:@"All"]){
                
                filterPredicate = [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", attribute, value];
            }
        }
        
        if([type isEqualToString:kSliderFilter]){
            NSString * attribute = (NSString *)filter[@"attributeName"];
            NSString * comparison = (NSString *)filter[@"comparison"];
            NSNumber * value = (NSNumber *)filter[@"value"];
            NSNumber * scale = (NSNumber *)filter[@"scale"];
            NSInteger mul = [value integerValue] * [scale integerValue];
            NSNumber * comparisonValue = [NSNumber numberWithLong:mul];
            if(value){
                NSString *formatString = [@"%K * %@" stringByReplacingOccurrencesOfString:@"*" withString:comparison];
                filterPredicate = [NSPredicate predicateWithFormat:formatString, attribute, comparisonValue];
            }
        }
        
        if(filtersPredicate && filterPredicate){
            filtersPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[filtersPredicate, filterPredicate]];
        } else if (filterPredicate){
            filtersPredicate = filterPredicate;
        }
    }
//    NSString * check = [filtersPredicate predicateFormat];

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
