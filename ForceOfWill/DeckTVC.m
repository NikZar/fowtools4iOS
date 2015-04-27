//
//  DeckTVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/24/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "DeckTVC.h"
#import "DeckCardTVCell.h"

@implementation DeckTVC

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 2;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.deck.cards count];
    } else {
        return [self.deck.side count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeckCardTVCell *cell = (DeckCardTVCell *)[tableView dequeueReusableCellWithIdentifier:@"deckCardCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.deckCard = [[self.deck.cards allObjects] objectAtIndex:indexPath.row];
    } else {
        cell.deckCard = [[self.deck.side allObjects] objectAtIndex:indexPath.row];
    }
    
    [cell updateCell];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}


@end
