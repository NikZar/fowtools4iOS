//
//  FOWDocsTVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 12/21/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "FOWDocsTVC.h"
#import "FOWDocsVC.h"
#import "DocumentTableViewCell.h"

@interface FOWDocsTVC ()

@property (strong, nonatomic) NSArray * docs;

@end

static NSString *CellIdentifier = @"docCell";

@implementation FOWDocsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.docs = @[@"FOW_Comprehensive_Rule",@"FOW_Penalty_Guidelines",@"FOW_Tournament_Policy",@"FOW_Specific_Floor_Rules"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.docs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DocumentTableViewCell *cell = (DocumentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *fileName = (NSString *)[self.docs objectAtIndex: indexPath.row];
    cell.titleLabel.text = [fileName stringByReplacingOccurrencesOfString:@"_" withString:@" "];

    return cell;
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
