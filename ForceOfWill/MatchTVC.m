//
//  MatchTVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/30/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "MatchTVC.h"
#import "Turn+Management.h"

@interface MatchTVC ()

@end

@implementation MatchTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.entityName = @"LifeChange";
    self.cellIdentifier = @"lifeChangeCell";
    NSSortDescriptor *dateSD = [[NSSortDescriptor alloc]
                                initWithKey:@"date" ascending:YES];
    NSSortDescriptor *sectionSD = [[NSSortDescriptor alloc]
                                initWithKey:@"turn.number" ascending:YES];
    self.sortDescriptors = @[sectionSD, dateSD];
    self.sectionKeyNamePath = @"turn.description";
    self.fetchPredicate = [NSPredicate predicateWithFormat:@"turn.match = %@", self.match];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo name];
}

@end
