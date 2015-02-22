//
//  Card+REST.h
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/1/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "Card.h"
#import "CardREST.h"

@interface Card (REST)

- (void)updateWithCardREST: (CardREST *)cardREST;

@end
