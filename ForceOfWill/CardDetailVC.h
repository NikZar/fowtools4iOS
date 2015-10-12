//
//  CardDetailVC.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/10/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardDetailVC : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) Card *card;
@property (weak, nonatomic) NSManagedObjectContext * context;

@end
