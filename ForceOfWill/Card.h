//
//  Card.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/29/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Card : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSData * image;

@end
