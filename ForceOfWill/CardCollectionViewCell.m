//
//  CardCollectionViewCell.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "CardCollectionViewCell.h"
#import "AppDelegate.h"
@interface CardCollectionViewCell()

@property (nonatomic) BOOL isLoading;

@end

@implementation CardCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)updateCell
{
    if (self.card) {
        self.nameLabel.text = self.card.name;
        self.cardImageView.image = [[UIImage alloc] initWithData:self.card.image];
        self.slideView.layer.cornerRadius = 16;
        self.slideView.clipsToBounds = YES;
        self.textView.text = self.card.text;
        self.flipView.layer.cornerRadius = (self.flipView.frame.size.width/2);
        self.slideView.clipsToBounds = YES;
        
        self.cardImageView.image = [UIImage imageNamed:@"fow_back"];
        if(!self.card.image && !self.isLoading){
            self.isLoading = YES;
            [self loadImage];
        }
        else {
            self.cardImageView.image = [UIImage imageWithData:self.card.image];
        }
    }
}

-(void)loadImage
{
    CardCollectionViewCell *blockSelf = self;
    __block NSManagedObjectContext *mainContext = blockSelf.context;
    
    __block NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = blockSelf.context;
    
    __block NSString * loadingId = blockSelf.card.identifier;
    __block Card *blockCard = self.card;
    
    [temporaryContext performBlock:^{
        
        AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *path = [NSString stringWithFormat:@"%@%@", delegate.baseImageUrlString, blockSelf.card.imageUrl ];
        NSURL *url = [NSURL URLWithString: path];
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        NSData *data = [NSData dataWithContentsOfURL:url];
        app.networkActivityIndicatorVisible = NO;
        blockSelf.isLoading = NO;
        
        if(blockSelf.card.identifier == loadingId){
            blockSelf.cardImageView.image = [UIImage imageWithData:data];
        }
        
        blockCard.image = data;
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
        
    }];
}

@end
