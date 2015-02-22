//
//  YTVideoREST.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/22/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YTVideoREST : NSObject

@property (strong, nonatomic)  NSString * videoId;
@property (strong, nonatomic)  NSString * title;
@property (strong, nonatomic)  NSString * videoDescription;
@property (strong, nonatomic)  NSString * thumbnailUrl;

@end
