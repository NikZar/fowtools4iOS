//
//  DeckCardCell.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/25/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeckCard.h"

@interface DeckCardTVCell : UITableViewCell

@property (weak, nonatomic) DeckCard *deckCard;

- (void)updateCell;

@end
