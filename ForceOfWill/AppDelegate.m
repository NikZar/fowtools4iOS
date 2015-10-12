//
//  AppDelegate.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/26/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import <RestKit/RestKit.h>
#import <CoreData/CoreData.h>
#import "CardREST.h"
#import "DeckREST.h"
#import "DeckCardREST.h"
#import "MatchManager.h"
#import "Constants.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end

#define MODEL_NAME @"ForceOfWill" 
#define DATABASE_NAME @"ForceOfWill.sqlite"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureGlobals];

    // are you running on iOS8?
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound) categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else // iOS 7 or earlier
    {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
    
    
    [FBSDKLoginButton class];
    
    [self configureRK];
       
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
}

-(void)configureGlobals
{
    self.baseUrlString = @"http://forceofwill.herokuapp.com";
    self.baseImageUrlString = @"http://forceofwill.herokuapp.com/images";
}

-(void)configureRK
{
//    NSError *error = nil;
    
//    // initialize AFNetworking HTTPClient
//    NSURL *baseURL = [NSURL URLWithString:self.baseUrlString];
//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
//    
//    // initialize RestKit
//    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
//    NSManagedObjectModel *managedObjectModel = self.managedObjectModel;
//    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
//    BOOL success = RKEnsureDirectoryExistsAtPath(RKApplicationDataDirectory(), &error);
//    if (! success) {
//        RKLogError(@"Failed to create Application Data Directory at path '%@': %@", RKApplicationDataDirectory(), error);
//    }
//    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"Store.sqlite"];
//    NSPersistentStore *persistentStore = [managedObjectStore addSQLitePersistentStoreAtPath:path fromSeedDatabaseAtPath:nil withConfiguration:nil options:nil error:&error];
//    if (! persistentStore) {
//        RKLogError(@"Failed adding persistent store at path '%@': %@", path, error);
//    }
//    [managedObjectStore createManagedObjectContexts];
//    managedObjectStore.managedObjectCache = [[RKInMemoryManagedObjectCache alloc] initWithManagedObjectContext:managedObjectStore.persistentStoreManagedObjectContext];
//    
//    objectManager.managedObjectStore = managedObjectStore;

    RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:self.baseUrlString]];
                                
    // setup object mappings
    RKObjectMapping *cardMapping = [RKObjectMapping mappingForClass:[CardREST class]];
    [cardMapping addAttributeMappingsFromDictionary:@{ @"code": @"code",
                                                       @"Image path": @"imageUrl",
                                                       @"_id":@"identifier",
                                                       @"Cardtext":@"text",
                                                       @"Name":@"name",
                                                       @"Type":@"type",
                                                       @"ATK":@"atk",
                                                       @"DEF":@"def",
                                                       @"Subtype":@"subtype",
                                                       @"Race":@"race",
                                                       @"Expansion":@"expansionS",
                                                       @"Attribute":@"attribute",
                                                       @"CostTXT":@"costTXT",
                                                       @"Total Cost":@"totalCost",
                                                       @"Set":@"set",
                                                       @"Num":@"num"}];
    
    // setup object mappings
    RKObjectMapping *deckCardMapping = [RKObjectMapping mappingForClass:[DeckCardREST class]];
    [deckCardMapping addAttributeMappingsFromDictionary:@{ @"qty": @"qty"}];
    [deckCardMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"card" toKeyPath:@"card" withMapping:cardMapping]];
    
    
    // setup object mappings
    RKObjectMapping *deckMapping = [RKObjectMapping mappingForClass:[DeckREST class]];
    [deckMapping addAttributeMappingsFromDictionary:@{ @"title": @"title",
                                                       @"notes": @"notes",
                                                       @"_id":@"identifier",
                                                       @"privacy":@"privacy",
                                                       @"author":@"author",
                                                       @"date":@"lastUpdate"}];
    
    
    
    [deckMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"cards" toKeyPath:@"cards" withMapping:deckCardMapping]];
    [deckMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"side" toKeyPath:@"side" withMapping:deckCardMapping]];
    [deckMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"ruler" toKeyPath:@"ruler" withMapping:cardMapping]];
    
    // CARDS API: register mappings with the provider using a response descriptor
    RKResponseDescriptor *cardsResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:cardMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/api/cards"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:cardsResponseDescriptor];
    
    // DECKS API: register mappings with the provider using a response descriptor
    RKResponseDescriptor *decksResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:deckMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/api/decks"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:decksResponseDescriptor];
}

- (void)configureMatchManger
{
    [[MatchManager sharedManager] setMoc:self.managedObjectContext];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Facebook Delegate

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "indiezios.ForceOfWill" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:MODEL_NAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:DATABASE_NAME];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};

    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    BOOL needsMigration = [self managedObjectContextNeedsMigration];
    
    UIView * _hudView;
    if(needsMigration){
        UIViewController* controller = ((UINavigationController*)self.window.rootViewController).visibleViewController;
        UIView* controllerView = controller.view;
        
        _hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, controllerView.frame.size.width, controllerView.frame.size.height)];
        _hudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        _hudView.clipsToBounds = YES;
//        _hudView.layer.cornerRadius = 10.0;
        
        UIActivityIndicatorView *_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        float x = (controllerView.frame.size.width - _activityIndicatorView.bounds.size.width) / 2;
        float y = (controllerView.frame.size.height - _activityIndicatorView.bounds.size.height) / 2;
        
        _activityIndicatorView.frame = CGRectMake(x, y, _activityIndicatorView.bounds.size.width, _activityIndicatorView.bounds.size.height);
        [_hudView addSubview:_activityIndicatorView];
        [_activityIndicatorView startAnimating];
        
        UILabel *_captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y +50, controllerView.frame.size.width, 22)];
        _captionLabel.textAlignment = NSTextAlignmentCenter;
        _captionLabel.numberOfLines = 3;
        _captionLabel.backgroundColor = [UIColor clearColor];
        _captionLabel.textColor = [UIColor whiteColor];
        _captionLabel.textAlignment = NSTextAlignmentCenter;
        _captionLabel.text = @"Updating app data...";
        [_hudView addSubview:_captionLabel];
        
        [controllerView addSubview:_hudView];
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    if(needsMigration){
//        [UIView animateWithDuration:0.2 animations:^{
//            _hudView.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            [_hudView removeFromSuperview];
//        }];
        [_hudView removeFromSuperview];
    }
    
    return _managedObjectContext;
}

#pragma mark - Core Data Migration

- (BOOL)managedObjectContextNeedsMigration
{
    NSError *error = nil;
    
    NSURL *storeUrl = [[NSBundle mainBundle] URLForResource:MODEL_NAME withExtension:@"momd"];
    
    // Determine if a migration is needed
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType
                                                                                              URL:storeUrl
                                                                                            error:&error];
    NSManagedObjectModel *destinationModel = [self.persistentStoreCoordinator managedObjectModel];
    BOOL pscCompatibile = [destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
    NSLog(@"Migration needed? %d", !pscCompatibile);
    return !pscCompatibile;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Notifications

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"timer" ofType:@"mp3"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                                       error:nil];
        self.audioPlayer.numberOfLoops = -1; // -1 Infinite
        
        [self.audioPlayer play];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.audioPlayer stop];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSDate distantPast] forKey:kTimerEndDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Search

- (BOOL)application:(UIApplication * _Nonnull)application
willContinueUserActivityWithType:(NSString * _Nonnull)userActivityType
{
    NSLog(@"%@:", userActivityType);
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray *restorableObjects))restorationHandler {
    
    if(self.window.rootViewController){
        [self.window.rootViewController restoreUserActivityState:userActivity];
    }
    
    return YES;
}

-(void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity
{
    NSLog(@"%@:", userActivity);
}

-(void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error
{
    NSLog(@"%@: %@", userActivityType,  error);
}

@end
