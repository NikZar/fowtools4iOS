//
//  LoginVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "LoginVC.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupFBLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupFBLogin
{
    FBLoginView *loginView = [[FBLoginView alloc] init];
    
    loginView.frame = CGRectMake(80, 100, 200, 60);
    
    //loginView.delegate = self;
    
    [self.view addSubview:loginView];
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
