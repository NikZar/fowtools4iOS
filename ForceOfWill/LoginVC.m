//
//  LoginVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "LoginVC.h"

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
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.frame = CGRectMake(0, 100, 200, 40);
//    [self.view addSubview:loginButton];
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
