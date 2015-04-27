//
//  DeckCardCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/25/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "DeckCardTVCell.h"
#import "Card.h"

@interface DeckCardTVCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;

@end

@implementation DeckCardTVCell

- (void)updateCell
{
    self.nameLabel.text = self.deckCard.card.name;
    self.qtyLabel.text = [NSString stringWithFormat:@"%@x", self.deckCard.qty];
}

@end
