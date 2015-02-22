//
//  LifeChange.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/30/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Turn;

@interface LifeChange : NSManagedObject

@property (nonatomic, retain) NSNumber * aboutP1;
@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * lifePoints;
@property (nonatomic, retain) NSNumber * lifePointsOP;
@property (nonatomic, retain) Turn *turn;

@end
