//
//  CoreDataTVC.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/30/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTVC : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) NSManagedObjectContext *context;

@property (strong, nonatomic) NSString *cellIdentifier;
@property (strong, nonatomic) NSString *entityName;
@property (strong, nonatomic) NSArray *sortDescriptors;
@property (strong, nonatomic) NSPredicate *fetchPredicate;
@property (strong, nonatomic) NSString *sectionKeyNamePath;

@end
