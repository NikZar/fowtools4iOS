//
//  MatchTVCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/28/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "MatchTVCell.h"
#import "Constants.h"
#import "Match+Management.h"
#import "Enums.h"

@interface MatchTVCell()

@property (weak, nonatomic) IBOutlet UILabel *player1NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *player1LPLabel;

@property (weak, nonatomic) IBOutlet UILabel *player2LPLabel;
@property (weak, nonatomic) IBOutlet UILabel *player2NameLabel;

@end

@implementation MatchTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell
{
    self.player1NameLabel.text = self.match.nameP1?self.match.nameP1:kP1Name;
    self.player2NameLabel.text = self.match.nameP2?self.match.nameP2:kP2Name;
    
    [self updateLifePoints];
}

- (void)updateLifePoints
{
    NSComparisonResult comparisonResult;
    NSNumber * p1LP = [self.match currentLifePointsForPlayer:FOWPlayer1];
    self.player1LPLabel.text = [NSString stringWithFormat:@"%@",p1LP];
    comparisonResult = [p1LP compare:[NSNumber numberWithInt:0]];
    if ( (comparisonResult == NSOrderedSame) || (comparisonResult == NSOrderedAscending)){
        self.player1LPLabel.textColor = [UIColor redColor];
        self.player1NameLabel.textColor = [UIColor redColor];
    } else {
        self.player1LPLabel.textColor = kP1Color;
        self.player1NameLabel.textColor = kP1Color;
    }
    
    NSNumber * p2LP = [self.match currentLifePointsForPlayer:FOWPlayer2];
    self.player2LPLabel.text = [NSString stringWithFormat:@"%@",p2LP];
    comparisonResult = [p2LP compare:[NSNumber numberWithInt:0]];
    if ( (comparisonResult == NSOrderedSame) || (comparisonResult == NSOrderedAscending)){
        self.player2LPLabel.textColor = [UIColor redColor];
        self.player2NameLabel.textColor = [UIColor redColor];
    } else {
        self.player2LPLabel.textColor = kP2Color;
        self.player2NameLabel.textColor = kP2Color;
    }
}

@end
