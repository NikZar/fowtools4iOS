//
//  MatchTVCell.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/28/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Match.h"

@interface MatchTVCell : UITableViewCell

@property (weak, nonatomic) Match *match;

- (void)updateCell;

@end
