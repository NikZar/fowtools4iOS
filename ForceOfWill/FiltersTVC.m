//
//  FiltersTVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 5/18/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "FiltersTVC.h"
#import "FilterSliderTableViewCell.h"
#import "FilterSegmentedControlTableViewCell.h"
#import "FilterTextTableViewCell.h"
#import "Constants.h"

@interface FiltersTVC ()

@end

@implementation FiltersTVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIBarButtonItem * resetButton = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self.cardsVC action:@selector(resetFilters)];
    self.navigationItem.rightBarButtonItems = @[resetButton];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.cardsVC.filters count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *filter = (NSMutableDictionary *)[self.cardsVC.filters objectAtIndex:indexPath.row];
    
    if ([kTextFilter isEqualToString:(NSString *)filter[@"type"]]) {
        FilterTextTableViewCell *cell = (FilterTextTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"filterText" forIndexPath:indexPath];
        [cell updateCellWithFilter:filter];
        return cell;
    }
    else if ([kSegmentedFilter isEqualToString:(NSString *)filter[@"type"]]) {
        FilterSegmentedControlTableViewCell *cell = (FilterSegmentedControlTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"filterSegmentedControl" forIndexPath:indexPath];
        [cell updateCellWithFilter:filter];
        return cell;
    }
    else if ([kSliderFilter isEqualToString:(NSString *)filter[@"type"]]) {
        FilterSliderTableViewCell *cell = (FilterSliderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"filterSlider" forIndexPath:indexPath];
        [cell updateCellWithFilter:filter];
        return cell;
    }
    else {
        return nil;
    }

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
