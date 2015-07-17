//
//  FilterTextTableViewCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 6/17/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "FilterTextTableViewCell.h"

@interface FilterTextTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *filterTextField;
@property (weak, nonatomic) NSMutableDictionary *filter;

@end

@implementation FilterTextTableViewCell

- (void)updateCellWithFilter:(NSMutableDictionary *)filter
{
    self.filter = filter;
    self.titleLabel.text = [(NSString *)filter[@"title"] uppercaseString];
    self.filterTextField.placeholder = (NSString *)filter[@"title"];
    self.filterTextField.text = (NSString *)filter[@"value"];
    self.filterTextField.delegate = self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)textChanged:(id)sender {
    [self.filter setValue:self.filterTextField.text forKey:@"value"];
    [self.filterTextField resignFirstResponder];
}
- (IBAction)textIsChanging:(id)sender {
    [self.filter setValue:self.filterTextField.text forKey:@"value"];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end
