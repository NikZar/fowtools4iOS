//
//  DeckREST.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/23/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card+REST.h"

@interface DeckREST : NSObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * privacy;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSSet *cards;
@property (nonatomic, retain) NSSet *side;
@property (nonatomic, retain) CardREST *ruler;

@end
