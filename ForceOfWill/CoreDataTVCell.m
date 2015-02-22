//
//  CoreDataTVCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/30/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "CoreDataTVCell.h"

@implementation CoreDataTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell
{
    //implemented in all subclass
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

@end
