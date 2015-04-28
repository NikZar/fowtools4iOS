//
//  ToolsVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/11/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "ToolsVC.h"
#import "CardsVC.h"
#import "DecksTVC.h"
#import "LifePointsVC.h"
#import "FOWTVTVC.h"
#import "MatchesTVC.h"
#import "FOWDocsTVC.h"

@implementation ToolsVC

- (IBAction)lifePointsSelected:(id)sender {
    
    LifePointsVC * lpVC = [self.storyboard instantiateViewControllerWithIdentifier:@"lifepoints"];
    
    [self.navigationController pushViewController:lpVC animated:YES];
}

- (IBAction)cardsSelected:(id)sender {

    CardsVC * cVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cards"];
    
    [self.navigationController pushViewController:cVC animated:YES];
}

- (IBAction)decksSelected:(id)sender {
    
    DecksTVC * dVC = [self.storyboard instantiateViewControllerWithIdentifier:@"decks"];
    
    [self.navigationController pushViewController:dVC animated:YES];
}

- (IBAction)FOWTVSelected:(id)sender {
    FOWTVTVC * tvVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fowtv"];
    
    [self.navigationController pushViewController:tvVC animated:YES];
}

- (IBAction)MatchesSelected:(id)sender {
    MatchesTVC * mVC = [self.storyboard instantiateViewControllerWithIdentifier:@"matches"];
    
    [self.navigationController pushViewController:mVC animated:YES];
}

- (IBAction)FOWDocsSelected:(id)sender {
    FOWDocsTVC * docsTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"documents"];
    
    [self.navigationController pushViewController:docsTVC animated:YES];
}
@end