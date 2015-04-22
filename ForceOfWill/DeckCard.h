//
//  DeckCard.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/23/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Card;

@interface DeckCard : NSManagedObject

@property (nonatomic, retain) NSNumber * qty;
@property (nonatomic, retain) Card *card;

@end
