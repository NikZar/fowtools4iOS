//
//  YTVideoTVCell.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/23/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTVideoREST.h"

@interface YTVideoTVCell : UITableViewCell

@property (weak, nonatomic) YTVideoREST * video;

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

- (void)updateCell;

@end
