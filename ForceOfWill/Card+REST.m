//
//  Card+REST.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/1/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "Card+REST.h"

@implementation Card (REST)

- (void)updateWithCardREST: (CardREST *)cardREST{
    self.code = cardREST.code ? cardREST.code : self.code;
    self.name = cardREST.name ? cardREST.name : self.name;
    self.imageUrl = cardREST.imageUrl ? cardREST.imageUrl : self.imageUrl;
    self.identifier = cardREST.identifier ? cardREST.identifier : self.identifier;
    self.text = cardREST.text ? cardREST.text : self.text;
}

+(Card *)getCardWithID:(NSString *)identifier inManagedObjectContext: (NSManagedObjectContext *)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Card"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier LIKE %@", identifier];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if (!results || ([results count] == 0)) {
        return nil;
    } else {
        return [results firstObject];
    }
}

@end