//
//  DeckTVCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/24/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "DeckTVCell.h"
#import "Card.h"
#import "AppDelegate.h"
@interface DeckTVCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rulerImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *rulerLabel;

@end

@implementation DeckTVCell

- (void)updateCell
{
    self.titleLabel.text = self.deck.title;
    self.countLabel.text = [NSString stringWithFormat:@"%@ cards, %@ side", self.deck.cardsCount, self.deck.sideCount ];
    self.rulerLabel.text = (self.deck.ruler) ? self.deck.ruler.name : @"";
    
    self.rulerImageView.image = [UIImage imageNamed:@"fow_back"];
    if(self.deck.ruler && !self.deck.ruler.image){
        [self loadImage];
    }
    else if (self.deck.ruler && self.deck.ruler.image){
        self.rulerImageView.image = [UIImage imageWithData:self.deck.ruler.image];
    }
}

-(void)loadImage
{
    __block NSManagedObjectContext *mainContext = self.context;
    
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = self.context;
    
    __block NSString * loadingId = self.deck.ruler.identifier;
    
    [temporaryContext performBlock:^{

        AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *path = [NSString stringWithFormat:@"%@%@", delegate.baseImageUrlString, self.deck.ruler.imageUrl ];
        NSURL *url = [NSURL URLWithString: path];
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        NSData *data = [NSData dataWithContentsOfURL:url];
        app.networkActivityIndicatorVisible = NO;
        
        if(self.deck.ruler.identifier == loadingId){
            self.deck.ruler.image = data;
            self.rulerImageView.image = [UIImage imageWithData:data];
            
            // push to parent
            NSError *error = nil;
            if (![temporaryContext save:&error])
            {
                NSLog(@"Error in temporaryContext: %@", error.localizedDescription);
            }
            
            // save parent to disk asynchronously
            [mainContext performBlock:^{
                NSError *error;
                if (![mainContext save:&error])
                {
                    NSLog(@"Error in mainContext: %@", error.localizedDescription);
                }
            }];
        }
        
    }];
}


@end
