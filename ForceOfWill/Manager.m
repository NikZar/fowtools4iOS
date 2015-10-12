//
//  Manager.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 9/19/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "Manager.h"

@implementation Manager

+ (id)sharedManager {
    static id sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

@end
