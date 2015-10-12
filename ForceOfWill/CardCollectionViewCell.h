//
//  CardCollectionViewCell.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 10/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) Card * card;
@property (weak, nonatomic) NSManagedObjectContext *context;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *slideView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *flipView;

-(void)updateCell;

@end
