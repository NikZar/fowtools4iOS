//
//  DeckCardREST.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/25/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CardREST.h"

@interface DeckCardREST : NSObject

@property (nonatomic, retain) NSNumber * qty;
@property (nonatomic, retain) CardREST *card;

@end
