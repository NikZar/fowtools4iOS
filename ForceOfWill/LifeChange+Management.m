//
//  LifeChange+Management.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "LifeChange+Management.h"

@implementation LifeChange (Management)

+ (LifeChange *)newLifeChangeInMOC:(NSManagedObjectContext*)moc
{
    LifeChange *newLifeChange = [NSEntityDescription
                     insertNewObjectForEntityForName:@"LifeChange"
                     inManagedObjectContext:moc];
    newLifeChange.date = [NSDate new];
    return newLifeChange;
}

@end
