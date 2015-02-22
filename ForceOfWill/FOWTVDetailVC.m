//
//  FOWTVDetailVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/22/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "FOWTVDetailVC.h"

@interface FOWTVDetailVC ()

@property (weak, nonatomic) IBOutlet YTPlayerView *playerView;

@end

@implementation FOWTVDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView.delegate = self;
    [self.playerView loadWithVideoId:self.video.videoId playerVars:@{
                                                                     @"autoplay":@1,
                                                                     @"theme":@"dark"
                                                                     }];
    self.playerView.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playerViewDidBecomeReady:(YTPlayerView *)playerView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Playback started" object:self];
    [self.playerView playVideo];
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
