//
//  CardDetailVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/10/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "CardDetailVC.h"
#import "AppDelegate.h"

@interface CardDetailVC()

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *atkDefLabel;
@property (weak, nonatomic) IBOutlet UITextView *cardTextView;

@end


@implementation CardDetailVC

-(void)viewDidLoad
{
    self.navigationItem.title = self.card.name;
    
    self.nameLabel.text = self.card.name;
    self.typeLabel.text = self.card.type;
    self.subtypeLabel.text = @"";
    self.cardTextView.text = self.card.text;
    
    self.cardImageView.image = [UIImage imageNamed:@"fow_back"];
    if(self.card && !self.card.image){
        [self loadImage];
    }
    else if (self.card && self.card.image){
        self.cardImageView.image = [UIImage imageWithData:self.card.image];
    }
}

-(void)loadImage
{
    __block NSManagedObjectContext *mainContext = self.context;
    
    NSManagedObjectContext *temporaryContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    temporaryContext.parentContext = self.context;
    
    [temporaryContext performBlock:^{
        
        AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSString *path = [NSString stringWithFormat:@"%@%@", delegate.baseImageUrlString, self.card.imageUrl ];
        NSURL *url = [NSURL URLWithString: path];
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        NSData *data = [NSData dataWithContentsOfURL:url];
        app.networkActivityIndicatorVisible = NO;
        
   
        self.card.image = data;
        self.cardImageView.image = [UIImage imageWithData:data];
        
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
