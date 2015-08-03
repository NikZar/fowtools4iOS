//
//  CardsVC.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/26/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CardsCVC : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) NSMutableArray *filters;

- (void)resetFilters;

@end
