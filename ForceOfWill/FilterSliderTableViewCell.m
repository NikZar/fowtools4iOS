//
//  FilterSliderTableViewCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 6/17/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "FilterSliderTableViewCell.h"

@interface FilterSliderTableViewCell()

@property (strong, nonatomic) NSString * title;
@property (weak, nonatomic) NSMutableDictionary *filter;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *filterSlider;

@end

@implementation FilterSliderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateCellWithFilter:(NSMutableDictionary *)filter
{
    self.title = (NSString *)filter[@"title"];
    self.filter = filter;
    
    NSInteger value = [(NSNumber *)filter[@"value"] intValue];
    NSInteger min = [(NSNumber *)filter[@"min"] intValue];
    NSInteger max = [(NSNumber *)filter[@"max"] intValue];
    NSInteger scale = [(NSNumber *)filter[@"scale"] intValue];
    
    self.filterSlider.minimumValue = min;
    self.filterSlider.maximumValue = max;
    
    [self.filterSlider setValue:value]; // Sets your slider to this value
    self.titleLabel.text = [NSString stringWithFormat:@"%@: %ld", self.title, value*scale];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)valueChanged:(UISlider*)sender {
    NSInteger scale = [(NSNumber *)self.filter[@"scale"] intValue];
    int discreteValue = roundl([sender value]); // Rounds float to an integer
    [sender setValue:(float)discreteValue]; // Sets your slider to this value
    self.titleLabel.text = [NSString stringWithFormat:@"%@: %ld", self.title, discreteValue*scale];
    [self.filter setValue:[NSNumber numberWithInt:discreteValue] forKey:@"value"];
}



@end
