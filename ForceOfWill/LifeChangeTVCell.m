//
//  LifeChangeTVCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/30/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "LifeChangeTVCell.h"
#import "LifeChange.h"

@interface LifeChangeTVCell()

@property (weak, nonatomic) IBOutlet UILabel *player1LCLabel;
@property (weak, nonatomic) IBOutlet UILabel *player1LPLabel;

@property (weak, nonatomic) IBOutlet UILabel *player2LCLabel;
@property (weak, nonatomic) IBOutlet UILabel *player2LPLabel;

@end

@implementation LifeChangeTVCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCell
{
    if([self.managedObject isKindOfClass:[LifeChange class]]){
        LifeChange *lifeChange = (LifeChange *)self.managedObject;
        if([lifeChange.aboutP1 boolValue]){
            
            if([lifeChange.amount compare:@0] == NSOrderedAscending){
                self.player1LCLabel.text = [NSString stringWithFormat:@"%@",lifeChange.amount];
                self.player1LCLabel.textColor = [UIColor redColor];
            } else {
                self.player1LCLabel.text = [NSString stringWithFormat:@"+%@",lifeChange.amount];
                self.player1LCLabel.textColor = [UIColor greenColor];
            }
            
            self.player1LPLabel.text = [NSString stringWithFormat:@"%@",lifeChange.lifePoints];
            
            self.player2LCLabel.text = @"";
            self.player2LPLabel.text = [NSString stringWithFormat:@"%@",lifeChange.lifePointsOP];
        } else {
            
            if([lifeChange.amount compare:@0] == NSOrderedAscending){
                self.player2LCLabel.text = [NSString stringWithFormat:@"%@",lifeChange.amount];
                self.player2LCLabel.textColor = [UIColor redColor];
            } else {
                self.player2LCLabel.text = [NSString stringWithFormat:@"+%@",lifeChange.amount];
                self.player2LCLabel.textColor = [UIColor greenColor];
            }
            self.player2LPLabel.text = [NSString stringWithFormat:@"%@",lifeChange.lifePoints];
            
            self.player1LCLabel.text = @"";
            self.player1LPLabel.text = [NSString stringWithFormat:@"%@",lifeChange.lifePointsOP];
        }
    }
}

@end
