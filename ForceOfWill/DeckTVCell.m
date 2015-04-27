//
//  DeckTVCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/24/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "DeckTVCell.h"
@interface DeckTVCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation DeckTVCell

- (void)updateCell
{
    self.titleLabel.text = self.deck.title;
}

@end
