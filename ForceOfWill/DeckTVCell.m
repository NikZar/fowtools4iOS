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
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rulerImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *rulerLabel;
@property (weak, nonatomic) IBOutlet UIView *windBullet;
@property (weak, nonatomic) IBOutlet UIView *darknessBullet;
@property (weak, nonatomic) IBOutlet UIView *fireBullet;
@property (weak, nonatomic) IBOutlet UIView *waterBullet;
@property (weak, nonatomic) IBOutlet UIView *lightBullet;
@property (nonatomic) BOOL loaded;

@end

@implementation DeckTVCell

- (void)updateCell
{
    if(!self.loaded){
        NSArray *bullets = @[self.windBullet, self.darknessBullet, self.fireBullet, self.waterBullet, self.lightBullet];
        for (UIView *bullet in bullets) {
            bullet.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            bullet.layer.borderWidth = 1.0f;
            bullet.clipsToBounds = YES;
            bullet.layer.cornerRadius =  7.0f;
        }
        self.loaded = YES;
    }
    
    self.windBullet.hidden = ![self.deck.isWind boolValue];
    self.darknessBullet.hidden = ![self.deck.isDarkness boolValue];
    self.fireBullet.hidden = ![self.deck.isFire boolValue];
    self.waterBullet.hidden = ![self.deck.isWater boolValue];
    self.lightBullet.hidden = ![self.deck.isLight boolValue];
    
    self.titleLabel.text = self.deck.title;
    self.countLabel.text = [NSString stringWithFormat:@"%@ cards, %@ side", self.deck.cardsCount, self.deck.sideCount ];
    self.rulerLabel.text = (self.deck.ruler) ? self.deck.ruler.name : @"";
    self.authorLabel.text = [NSString stringWithFormat:@"by %@",self.deck.author];
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
    __block DeckTVCell *blockSelf = self;
    __block NSManagedObjectContext *mainContext = blockSelf.context;
    
    __block NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = blockSelf.context;
    
    __block NSString * loadingId = blockSelf.deck.ruler.identifier;
    
    [temporaryContext performBlock:^{
        @autoreleasepool {
            AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSString *path = [NSString stringWithFormat:@"%@%@", delegate.baseImageUrlString, blockSelf.deck.ruler.imageUrl ];
            NSURL *url = [NSURL URLWithString: path];
            UIApplication* app = [UIApplication sharedApplication];
            app.networkActivityIndicatorVisible = YES;
            NSData *data = [NSData dataWithContentsOfURL:url];
            app.networkActivityIndicatorVisible = NO;
            
            if(blockSelf.deck.ruler.identifier == loadingId){
                blockSelf.deck.ruler.image = data;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    blockSelf.rulerImageView.image = [UIImage imageWithData:data];
                });
                
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
        }
    }];
}


@end
