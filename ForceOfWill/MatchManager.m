//
//  MatchManager.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/27/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "MatchManager.h"
#import "Match+Management.h"
#import "Turn+Management.h"
#import "LifeChange+Management.h"
#import "Constants.h"

@interface MatchManager()

@property (strong, readwrite, nonatomic) Turn *currentTurn;
@property (strong, readwrite, nonatomic) Match *currentMatch;

@end

@implementation MatchManager

@synthesize currentMatch = _currentMatch;

+ (id)sharedMatchManager {
    static MatchManager *sharedMatchManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMatchManager = [[self alloc] init];
    });
    return sharedMatchManager;
}

- (void)endMatch
{
    self.currentTurn = nil;
    self.currentMatch = nil;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Getters
- (Match *)currentMatch
{
    if(!_currentMatch){
         _currentMatch = [Match newMatchInMOC: self.moc];
        [self save];
    }
    
    return _currentMatch;
}

- (NSString *)player1Name{
    if(!self.currentMatch.nameP1){
        self.currentMatch.nameP1 = kP1Name;
    }
    return self.currentMatch.nameP1;
}

- (NSString *)player2Name{
    if(!self.currentMatch.nameP2){
        self.currentMatch.nameP2 = kP2Name;
    }
    return self.currentMatch.nameP2;
}

- (NSNumber *)player1LP
{
    return [self.currentMatch currentLifePointsForPlayer:FOWPlayer1];
}

- (NSNumber *)player2LP
{
    return [self.currentMatch currentLifePointsForPlayer:FOWPlayer2];
}

- (Turn *)currentTurn
{
    if(!_currentTurn){
        [self newTurnForPlayer:kDefaultInitialPlayer];
    }
    return _currentTurn;
}

#pragma mark - Setters

- (void)setMoc:(NSManagedObjectContext *)moc
{
    _moc = moc;
    
    Match * latestMatch = [Match latestMatchInMOC:moc];
    if(latestMatch){
        _currentMatch = latestMatch;
    }
    else{
        _currentMatch = [Match newMatchInMOC: moc];
    }
}

- (void)setPlayer1Name:(NSString *)player1Name
{
    self.currentMatch.nameP1 = player1Name;
    [self save];
}

- (void)setPlayer2Name:(NSString *)player2Name
{
    self.currentMatch.nameP2 = player2Name;
    [self save];
}

- (void)setPlayer1LP:(NSNumber *)player1LP
{
    NSNumber *amount = [NSNumber numberWithInt:([player1LP intValue] - [self.player1LP intValue])];
    NSComparisonResult comparisonResult = [amount compare:[NSNumber numberWithInt:0]];
    if(!(comparisonResult == NSOrderedSame)){
        [self updateLifeChangesWithLifePoints:player1LP WithAmount: amount withActivePlayer:FOWPlayer1];
    }
}

- (void)setPlayer2LP:(NSNumber *)player2LP
{
    NSNumber *amount = [NSNumber numberWithInt:([player2LP intValue] - [self.player2LP intValue])];
    NSComparisonResult comparisonResult = [amount compare:[NSNumber numberWithInt:0]];
    if(!(comparisonResult == NSOrderedSame)){
        [self updateLifeChangesWithLifePoints:player2LP WithAmount: amount withActivePlayer:FOWPlayer2];
    }
}

#pragma mark - Utilities

- (void)updateLifeChangesWithLifePoints:(NSNumber *)playerLP WithAmount:(NSNumber *)amount withActivePlayer:(FOWPlayer)player
{
    BOOL isPlayer1 = (player == FOWPlayer1);
    LifeChange *lifeChange = [LifeChange newLifeChangeInMOC:self.moc];
    lifeChange.amount = amount;
    lifeChange.aboutP1 = [NSNumber numberWithBool:isPlayer1];
    lifeChange.lifePoints = playerLP;
    lifeChange.turn = self.currentTurn;
    
    if(isPlayer1){
        lifeChange.lifePointsOP = self.player2LP;
    } else {
        lifeChange.lifePointsOP = self.player1LP;
    }
    
    [self.currentTurn addLifeChangesObject:lifeChange];
    [self save];
}

- (void)newTurnForPlayer:(FOWPlayer)player
{
    BOOL isPlayer1Active = (player == FOWPlayer1);
    Turn *turn = [Turn newTurnInMOC:self.moc];
    turn.activeP1 = [NSNumber numberWithBool:isPlayer1Active];
    turn.match = self.currentMatch;
    if(_currentTurn){
        turn.number = [NSNumber numberWithInt:([self.currentTurn.number intValue]+1)];
    } else {
        turn.number = @0;
    }
    [self.currentMatch addTurnsObject:turn];
    [self save];
    self.currentTurn = turn;
}

- (void)save
{
    NSError *error = nil;
    if(![self.moc save:&error]){
        NSLog(@"Error updating Match!");
    }
}

- (void)dealloc {
    NSLog(@"You shall not pass!!!");
}

@end
