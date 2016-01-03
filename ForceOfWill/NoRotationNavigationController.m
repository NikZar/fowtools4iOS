//
//  NoRotationNavigationController.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 6/21/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "NoRotationNavigationController.h"
#import "AppDelegate.h"
#import "Card+REST.h"
#import "CardDetailVC.h"
#import "AppDelegate.h"

@import CoreSpotlight;

@interface NoRotationNavigationController ()

@end

@implementation NoRotationNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)restoreUserActivityState:(NSUserActivity *)userActivity
{
    if ([[userActivity activityType] isEqualToString:CSSearchableItemActionType]) {
        // This activity represents an item indexed using Core Spotlight, so restore the context related to the unique identifier.
        // The unique identifier of the Core Spotlight item is set in the activity’s userInfo for the key CSSearchableItemActivityIdentifier.
        
        NSString *uniqueIdentifier = [userActivity.userInfo objectForKey:CSSearchableItemActivityIdentifier];
        
        AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *mainContext = [delegate managedObjectContext];
        
        Card * card = [Card getCardWithID:uniqueIdentifier inManagedObjectContext:mainContext];
        
        if(card){
            self.navigationBarHidden = NO;
            CardDetailVC * cdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cardDetail"];
            cdVC.context = mainContext;
            cdVC.card = card;
            [self pushViewController:cdVC animated:false];
        }
    }
}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return [self.topViewController supportedInterfaceOrientations];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
