//
//  FilterSegmentedControlTableViewCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 6/17/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "FilterSegmentedControlTableViewCell.h"
@interface FilterSegmentedControlTableViewCell()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) NSMutableDictionary *filter;
@end

@implementation FilterSegmentedControlTableViewCell

- (void)updateCellWithFilter:(NSMutableDictionary *)filter
{
    self.filter = filter;
    
    NSArray *options = (NSArray *)self.filter[@"options"];
    NSString *value = (NSString *)self.filter[@"value"];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:options];
    
    [self.segmentedControl.superview addSubview:segmentedControl];
    segmentedControl.frame = CGRectMake(self.segmentedControl.frame.origin.x, self.segmentedControl.frame.origin.y, 300 , self.segmentedControl.frame.size.height);
    
    UIFont *font = [UIFont boldSystemFontOfSize:8.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [segmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    [segmentedControl setSelectedSegmentIndex:[options indexOfObject:value]];

    [self.segmentedControl removeFromSuperview];
    self.segmentedControl = segmentedControl;
    [self.segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)segmentChanged:(id)sender {
    NSArray *options = (NSArray *)self.filter[@"options"];
    NSString *selectedOption = (NSString *)[options objectAtIndex:self.segmentedControl.selectedSegmentIndex];
    [self.filter setValue:selectedOption forKey:@"value"];
}

@end
