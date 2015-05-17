//
//  FOWDocsTVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 12/21/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "FOWDocsTVC.h"
#import "FOWDocsVC.h"

@interface FOWDocsTVC ()

@property (strong, nonatomic) NSArray * docs;

@end

@implementation FOWDocsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.docs = @[@"FOW_Rules_CR_5.01",@"FOW_Penalty_Guidelines",@"FOW_Tournament_Policy"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if([segue.identifier isEqualToString:@"docDetail"]){
        FOWDocsVC * docVC = (FOWDocsVC *)segue.destinationViewController;
        NSIndexPath * selectedIndexPath = [[self.tableView indexPathsForSelectedRows] firstObject];
        docVC.documentTitle = [self.docs objectAtIndex: selectedIndexPath.row];
        docVC.documentType = @"pdf";
//    }
}


@end
