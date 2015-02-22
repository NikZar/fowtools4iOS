//
//  MatchTVC.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/30/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTVC.h"
#import "Match.h"

@interface MatchTVC : CoreDataTVC

@property (strong, nonatomic) Match *match;

@end
