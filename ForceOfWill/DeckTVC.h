//
//  DeckTVC.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/24/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface DeckTVC : UITableViewController

@property (strong, nonatomic) Deck* deck;
@property (weak,nonatomic) NSManagedObjectContext *context;

@end
