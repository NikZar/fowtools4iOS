//
//  MainVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/26/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString * identifier;
        
    switch (indexPath.row) {
        case 0:
            identifier = @"tools";
            break;
        case 1:
            identifier = @"lifePoints";
            break;
        case 2:
            identifier = @"matches";
            break;
        case 3:
            identifier = @"cardsSlider";
            break;
        case 4:
            identifier = @"decks";
            break;
        case 5:
            identifier = @"FOWTV";
            break;
        case 6:
            identifier = @"docs";
            break;
        case 7:
            identifier = @"info";
            break;
        case 8:
            identifier = @"login";
            break;
        default:
            identifier = @"cardsSlider";
            break;
    }
    
    return identifier;
}

-(void)configureLeftMenuButton:(UIButton *)button
{
    button.frame = CGRectMake(0, 0, 40, 40);
    
    [button setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
}

-(NSIndexPath *)initialIndexPathForLeftMenu
{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

// Enabling Deepnes on left menu
- (BOOL)deepnessForLeftMenu
{
    return YES;
}

@end
