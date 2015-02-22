//
//  InfoVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 12/21/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "InfoVC.h"
#import "Constants.h"

@interface InfoVC ()

@property (weak, nonatomic) IBOutlet UIButton *urlButton;
@property (weak, nonatomic) IBOutlet UIButton *officialUrlButton;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation InfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlButton.titleLabel.text = kFOWToolsWebsite;
    self.officialUrlButton.titleLabel.text = kOfficialWebsite;
    self.versionLabel.text = [NSString stringWithFormat:@"Version: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)visitWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFOWToolsWebsite]];
}

- (IBAction)visitOfficialWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kOfficialWebsite]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
