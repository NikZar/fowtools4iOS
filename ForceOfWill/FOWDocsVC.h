//
//  FOWDocsVC.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 12/2/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"

@interface FOWDocsVC : UIViewController <ReaderViewControllerDelegate>

@property (strong, nonatomic) NSString *documentTitle;
@property (strong, nonatomic) NSString *documentType;

@end
