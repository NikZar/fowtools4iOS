//
//  CardsVC.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/26/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreData/CoreData.h>

@interface CardsVC : UICollectionViewController <FBLoginViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UISearchDisplayDelegate>

@end
