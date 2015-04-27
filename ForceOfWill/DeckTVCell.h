//
//  DeckTVCell.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/24/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface DeckTVCell : UITableViewCell

@property (weak, nonatomic) Deck *deck;

- (void)updateCell;

@end
