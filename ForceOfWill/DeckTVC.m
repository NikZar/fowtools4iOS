//
//  DeckTVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/24/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "DeckTVC.h"
#import "DeckCardTVCell.h"
#import "Card.h"
#import "CardDetailVC.h"

@interface DeckTVC()

@property (strong, nonatomic) NSArray *rulers;
@property (strong, nonatomic) NSArray *stones;
@property (strong, nonatomic) NSArray *resonators;
@property (strong, nonatomic) NSArray *spells;
@property (strong, nonatomic) NSArray *additions;
@property (strong, nonatomic) NSArray *regalias;

@end

@implementation DeckTVC

#pragma mark - Table view data source

- (void)viewDidLoad
{
    [super viewDidLoad];
//    
//    for (DeckCard *deckCard in self.deck.cards) {
//        NSLog(@"%@ - %@", deckCard.qty , deckCard.card.name);
//    }
//    
    NSPredicate *rulerPred = [NSPredicate predicateWithFormat:@"card.type == 'Ruler'"];
    NSPredicate *jRulerPred = [NSPredicate predicateWithFormat:@"card.type == 'J-Ruler'"];
    self.rulers = [[self.deck.cards allObjects] filteredArrayUsingPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:@[rulerPred, jRulerPred]]];
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:self.rulers];
    self.rulers = [orderedSet array];
    
    NSPredicate *stonePred = [NSPredicate predicateWithFormat:@"card.type == 'Magic Stone'"];
    self.stones = [[self.deck.cards allObjects] filteredArrayUsingPredicate:stonePred];
    orderedSet = [NSOrderedSet orderedSetWithArray:self.stones];
    self.stones = [orderedSet array];
    
    NSPredicate *resonatorPred = [NSPredicate predicateWithFormat:@"card.type == 'Resonator'"];
    self.resonators = [[self.deck.cards allObjects] filteredArrayUsingPredicate:resonatorPred];
    orderedSet = [NSOrderedSet orderedSetWithArray:self.resonators];
    self.resonators = [orderedSet array];
    
    NSPredicate *additionPred = [NSPredicate predicateWithFormat:@"card.type == 'Addition'"];
    self.spells = [[self.deck.cards allObjects] filteredArrayUsingPredicate:additionPred];
    orderedSet = [NSOrderedSet orderedSetWithArray:self.spells];
    self.spells = [orderedSet array];
    
    NSPredicate *regaliaPred = [NSPredicate predicateWithFormat:@"card.type == 'Regalia'"];
    self.regalias = [[self.deck.cards allObjects] filteredArrayUsingPredicate:regaliaPred];
    orderedSet = [NSOrderedSet orderedSetWithArray:self.regalias];
    self.regalias = [orderedSet array];
    
    NSPredicate *spellPred = [NSPredicate predicateWithFormat:@"card.type == 'Spell'"];
    self.additions = [[self.deck.cards allObjects] filteredArrayUsingPredicate:spellPred];
    orderedSet = [NSOrderedSet orderedSetWithArray:self.additions];
    self.additions = [orderedSet array];
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 8;
    return sections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Deck";
    }
    if (section == 1) {
        return @"Ruler";
    }
    if (section == 2) {
        return @"Stones";
    }
    if (section == 3) {
        return @"Resonators";
    }
    if (section == 4) {
        return @"Spells";
    }
    if (section == 5) {
        return @"Additions";
    }
    if (section == 6) {
        return @"Regalias";
    }
    else {
        return @"Side";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    if (section == 1) {
        return [self.rulers count];
    }
    if (section == 2) {
        return [self.stones count];
    }
    if (section == 3) {
        return [self.resonators count];
    }
    if (section == 4) {
        return [self.spells count];
    }
    if (section == 5) {
        return [self.additions count];
    }
    if (section == 6) {
        return [self.regalias count];
    }
    else {
        return [self.deck.side count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeckCardTVCell *cell = (DeckCardTVCell *)[tableView dequeueReusableCellWithIdentifier:@"deckCardCell" forIndexPath:indexPath];
    NSInteger section = indexPath.section;
    if (section == 0) {
        //never called
    }
    else if (section == 1) {
        cell.deckCard = [self.rulers objectAtIndex:indexPath.row];
    }
    else if (section == 2) {
        cell.deckCard = [self.stones objectAtIndex:indexPath.row];
    }
    else if (section == 3) {
        cell.deckCard = [self.resonators objectAtIndex:indexPath.row];
    }
    else if (section == 4) {
        cell.deckCard = [self.spells objectAtIndex:indexPath.row];
    }
    else if (section == 5) {
        cell.deckCard = [self.additions objectAtIndex:indexPath.row];
    }
    else if (section == 6) {
        cell.deckCard = [self.regalias objectAtIndex:indexPath.row];
    }
    else {
        cell.deckCard = [[self.deck.side allObjects] objectAtIndex:indexPath.row];
    }
    
    [cell updateCell];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"deckCardDetail"]){
        CardDetailVC *cdVC = [segue destinationViewController];
        cdVC.context = self.context;
        
        NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
        
        DeckCard *deckCard;
        NSInteger section = indexPath.section;
        if (section == 0) {
            //never called
        }
        else if (section == 1) {
            deckCard = [self.rulers objectAtIndex:indexPath.row];
        }
        else if (section == 2) {
            deckCard = [self.stones objectAtIndex:indexPath.row];
        }
        else if (section == 3) {
            deckCard = [self.resonators objectAtIndex:indexPath.row];
        }
        else if (section == 4) {
            deckCard = [self.spells objectAtIndex:indexPath.row];
        }
        else if (section == 5) {
            deckCard = [self.additions objectAtIndex:indexPath.row];
        }
        else if (section == 6) {
            deckCard = [self.regalias objectAtIndex:indexPath.row];
        } else {
            deckCard = [[self.deck.side allObjects] objectAtIndex:indexPath.row];
        }
        
        cdVC.card = deckCard ? deckCard.card : nil;
        
    }
}


@end
