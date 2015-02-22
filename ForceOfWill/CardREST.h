//
//  CardREST.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/1/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardREST : NSObject

@property (nonatomic, strong) NSString * code;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * imageUrl;
@property (nonatomic, strong) NSString * identifier;
@property (nonatomic, strong) NSString * text;

@end
