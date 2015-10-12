//
//  CardImageVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 9/22/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "CardImageVC.h"

@interface CardImageVC ()

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@end

@implementation CardImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.cardImageView.image = [UIImage imageWithData:self.card.image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
