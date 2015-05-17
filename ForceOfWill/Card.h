//
//  Card.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 5/11/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * subtype;
@property (nonatomic, retain) NSString * race;
@property (nonatomic, retain) NSString * attribute;
@property (nonatomic, retain) NSNumber * atk;
@property (nonatomic, retain) NSNumber * def;
@property (nonatomic, retain) NSString * costTXT;
@property (nonatomic, retain) NSNumber * attributeCost;
@property (nonatomic, retain) NSNumber * freeCost;
@property (nonatomic, retain) NSNumber * totalCost;
@property (nonatomic, retain) NSNumber * expansion;
@property (nonatomic, retain) NSString * rarity;
@property (nonatomic, retain) NSNumber * num;
@property (nonatomic, retain) NSNumber * set;

@end
