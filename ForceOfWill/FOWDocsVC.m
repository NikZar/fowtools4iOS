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

@end

@implementation FOWDocsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *file = [[NSBundle mainBundle] pathForResource:self.documentTitle ofType:self.documentType];
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:file password:nil];
    
    if (document != nil)
    {
        ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        readerViewController.delegate = self;
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:^{
            
        }];
    }
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
