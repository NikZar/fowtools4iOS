//
//  CardCollectionViewCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "CardCollectionViewCell.h"

@implementation CardCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)updateCell
{
    if (self.card) {
        self.nameLabel.text = self.card.name;
        self.cardImageView.image = [[UIImage alloc] initWithData:self.card.image];
        self.slideView.layer.cornerRadius = 16;
        self.slideView.clipsToBounds = YES;
        self.textView.text = self.card.text;
        self.flipView.layer.cornerRadius = (self.flipView.frame.size.width/2);
        self.slideView.clipsToBounds = YES;
    }
}

@end
