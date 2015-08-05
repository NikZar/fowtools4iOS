//
//  FOWDocsVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 12/2/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "FOWDocsVC.h"
#import "ReaderViewController.h"

@interface FOWDocsVC ()

@property (strong, nonatomic) ReaderViewController *readerViewController;

@end

@implementation FOWDocsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *file = [[NSBundle mainBundle] pathForResource:self.documentTitle ofType:self.documentType];
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:file password:nil];
    
    if (document != nil)
    {
        self.readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        self.readerViewController.delegate = self;
        
        self.readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.readerViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [self presentViewController:self.readerViewController animated:YES completion:^{
            [UIView beginAnimations:@"View Flip" context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationTransition:
             UIViewAnimationTransitionCurlUp forView:self.readerViewController.view cache:NO];
            [UIView commitAnimations];
        }];
    }
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:
     UIViewAnimationTransitionCurlUp forView:self.readerViewController.view cache:NO];
    [UIView commitAnimations];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
