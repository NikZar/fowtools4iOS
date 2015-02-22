//
//  FOWTVDetailVC.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/22/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTVideoREST.h"
#import "YTPlayerView.h"

@interface FOWTVDetailVC : UIViewController <YTPlayerViewDelegate>

@property (weak, nonatomic) YTVideoREST * video;

@end
