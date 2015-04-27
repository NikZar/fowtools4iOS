//
//  AppDelegate.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/26/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSString * baseUrlString;
@property (strong, nonatomic) NSString * baseImageUrlString;

@property (strong, nonatomic) NSDate *endTimerDate;

@property (strong, nonatomic) NSString *facebookToken;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

