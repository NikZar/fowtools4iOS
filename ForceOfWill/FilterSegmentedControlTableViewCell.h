//
//  FilterSegmentedControlTableViewCell.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 6/17/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSegmentedControlTableViewCell : UITableViewCell

- (void)updateCellWithFilter:(NSMutableDictionary *)filter;

@end
