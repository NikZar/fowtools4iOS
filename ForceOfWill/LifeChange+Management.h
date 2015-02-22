//
//  LifeChange+Management.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "LifeChange.h"

@interface LifeChange (Management)

+ (LifeChange *)newLifeChangeInMOC:(NSManagedObjectContext*)moc;

@end
