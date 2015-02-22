//
//  YTVideoTVCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/23/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "YTVideoTVCell.h"

@implementation YTVideoTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell
{
    self.videoImageView.image = nil;
    self.descriptionTextView.text = self.video.videoDescription;
    self.descriptionTextView.textColor = [UIColor whiteColor];
    self.titleLabel.text = self.video.title;
    
    [NSThread detachNewThreadSelector:@selector(loadImage) toTarget:self withObject:nil];
}

- (void)loadImage
{
    NSURL * thumbnauilUrl = [NSURL URLWithString:self.video.thumbnailUrl];
    NSData *imageData = [NSData dataWithContentsOfURL:thumbnauilUrl];
    self.videoImageView.image = [UIImage imageWithData:imageData];
}

@end
