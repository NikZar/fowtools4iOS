//
//  LifePointsVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 11/1/14.
//  Copyright (c) 2014 IndieZiOS. All rights reserved.
//

#import "LifePointsVC.h"
#import "AppDelegate.h"
#import "MatchManager.h"
#import "MatchTVC.h"
#import "Constants.h"
#import "Turn+Management.h"

@interface LifePointsVC ()

@property (weak, nonatomic) AppDelegate * delegate;

@property (strong, nonatomic) NSNumber *player1LP;
@property (strong, nonatomic) NSNumber *player2LP;

@property (strong, nonatomic) NSNumber *numberMessageP1;
@property (strong, nonatomic) NSDate *lastModificationP1;
@property (strong, nonatomic) NSNumber *numberMessageP2;
@property (strong, nonatomic) NSDate *lastModificationP2;

@property (weak, nonatomic) IBOutlet UILabel *player1LPLabel;
@property (weak, nonatomic) IBOutlet UILabel *player2LPLabel;

@property (weak, nonatomic) IBOutlet UITextField *player1NameTextField;
@property (weak, nonatomic) IBOutlet UITextField *player2NameTextField;
@property (weak, nonatomic) IBOutlet UILabel *turnCounter;

@property (weak, nonatomic) MatchManager *matchManager;

@end

@implementation LifePointsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = [[UIApplication sharedApplication] delegate];
    
    self.player1NameTextField.delegate = self;
    self.player2NameTextField.delegate = self;
    
    self.matchManager = [MatchManager sharedMatchManager];
    
    self.turnCounter.clipsToBounds = YES;
    self.turnCounter.layer.cornerRadius = self.turnCounter.bounds.size.width/2;
    
    [self updateScores];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self forceNameSync];
    [self forceLPSync];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateScores
{
    self.player1LP = self.matchManager.player1LP;
    self.player2LP = self.matchManager.player2LP;
    self.player1NameTextField.text = self.matchManager.player1Name;
    self.player2NameTextField.text = self.matchManager.player2Name;
    
    self.numberMessageP1 = @0;
    self.numberMessageP2 = @0;
    
    if([self.matchManager.currentTurn.number compare:@0]==NSOrderedSame){
        self.turnCounter.backgroundColor = [UIColor lightGrayColor];
    }
    self.turnCounter.text = [self.matchManager.currentTurn.number description];
    
    [self updateUI];
    
}

- (void)updateUI
{
    self.player1LPLabel.text = [NSString stringWithFormat:@"%@", self.player1LP];
    self.player2LPLabel.text = [NSString stringWithFormat:@"%@", self.player2LP];
}

#pragma mark - Sync LP View with Controller

- (void)forceLPSync
{
    self.matchManager.player1LP = self.player1LP;
    self.matchManager.player2LP = self.player2LP;
}

- (void)forceNameSync
{
    self.matchManager.player1Name = self.player1NameTextField.text;
    self.matchManager.player2Name = self.player2NameTextField.text;
}

#pragma mark - Update

-(void)setPlayer1LP:(NSNumber *)player1LP
{
    if([player1LP compare:@0] == NSOrderedAscending){
        player1LP = @0;
        NSString *message = [NSString stringWithFormat:@"%@ wins!", self.player2NameTextField.text];
        [self showMessage:message withColor:kP2Color];
    }
    _player1LP = player1LP;
}

-(void)setPlayer2LP:(NSNumber *)player2LP
{
    if([player2LP compare:@0] == NSOrderedAscending){
        player2LP = @0;
        NSString *message = [NSString stringWithFormat:@"%@ wins!", self.player1NameTextField.text];
        [self showMessage:message withColor:kP1Color];
    }
    _player2LP = player2LP;
}

#pragma mark - Button callbacks
- (IBAction)plusP1:(id)sender {
    if([self.player1LP compare:@0] != NSOrderedSame){
        [self showMessage:[self numberToShowP1:@100] withColor:[UIColor greenColor]];
    }
    self.player1LP = [NSNumber numberWithInt:([self.player1LP intValue] + [@100 intValue])];
    [self updateUI];
}
- (IBAction)plusP2:(id)sender {
    if([self.player2LP compare:@0] != NSOrderedSame){
        [self showMessage:[self numberToShowP2:@100] withColor:[UIColor greenColor]];
    }
    self.player2LP = [NSNumber numberWithInt:([self.player2LP intValue] + [@100 intValue])];
    [self updateUI];
}
- (IBAction)minusP1:(id)sender {
    if([self.player1LP compare:@0] != NSOrderedSame){
        [self showMessage:[self numberToShowP1:@-100] withColor:[UIColor redColor]];
    }
    self.player1LP = [NSNumber numberWithInt:([self.player1LP intValue] - [@100 intValue])];
    [self updateUI];
}
- (IBAction)minusP2:(id)sender {
    if([self.player2LP compare:@0] != NSOrderedSame){
        [self showMessage:[self numberToShowP2:@-100] withColor:[UIColor redColor]];
    }
    self.player2LP = [NSNumber numberWithInt:([self.player2LP intValue] - [@100 intValue])];
    [self updateUI];
}

- (IBAction)resetGame:(id)sender {
    [self forceLPSync];
    [self.matchManager endMatch];
    [self forceNameSync];
    [self updateScores];
    [self showMessage:@"START!" withColor:[UIColor whiteColor]];
}

- (NSString *)numberToShowP1:(NSNumber *)delta
{
    if(-3 > [self.lastModificationP1 timeIntervalSinceNow]){
        [self forceLPSync];
        self.numberMessageP1 = @0;
    }
    
    if ([self.numberMessageP1 intValue]*[delta intValue]<= 0) {
        [self forceLPSync];
        self.numberMessageP1 = @0;
    }
    self.numberMessageP1 = [NSNumber numberWithInt:([self.numberMessageP1 intValue] + [delta intValue])];
    self.lastModificationP1 = [NSDate date];
    
    return [NSString stringWithFormat:([self.numberMessageP1 compare: @0] == NSOrderedAscending ? @"%@" : @"+%@"), self.numberMessageP1];
}

- (NSString *)numberToShowP2:(NSNumber *)delta
{
    if(-3 > [self.lastModificationP2 timeIntervalSinceNow]){
        [self forceLPSync];
        self.numberMessageP2 = @0;
    }
    if ([self.numberMessageP2 intValue]*[delta intValue]<= 0) {
        [self forceLPSync];
        self.numberMessageP2 = @0;
    }
    
    self.numberMessageP2 = [NSNumber numberWithInt:([self.numberMessageP2 intValue] + [delta intValue])];
    self.lastModificationP2 = [NSDate date];
    return [NSString stringWithFormat:([self.numberMessageP2 compare: @0] == NSOrderedAscending ? @"%@" : @"+%@"), self.numberMessageP2];
}

- (void)showMessage:(NSString *)message withColor:(UIColor *)color {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.text = message;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    [label sizeToFit];
    label.center = self.view.center;
    [self.view addSubview:label];
    [UIView animateWithDuration:2.5 animations:^{
        label.alpha = 0;
        label.transform = CGAffineTransformMakeScale(20, 20);
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self forceNameSync];
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Turn Buttons

- (IBAction)newPlayer2Turn:(id)sender {
    [self forceLPSync];
    [self.matchManager newTurnForPlayer:FOWPlayer2];
    NSString *message =  self.matchManager.currentTurn.description;
    [self showMessage:message withColor:kP2Color];
    [self updateTurnCounterForPlayer: FOWPlayer2];
}

- (IBAction)newPlayer1Turn:(id)sender {
    [self forceLPSync];
    [self.matchManager newTurnForPlayer:FOWPlayer1];
    NSString *message =  self.matchManager.currentTurn.description;
    [self showMessage:message withColor:kP1Color];
    [self updateTurnCounterForPlayer: FOWPlayer1];
    
}

- (void)updateTurnCounterForPlayer:(FOWPlayer)player
{
    [UIView animateWithDuration:2.5 animations:^{
        if (player == FOWPlayer1) {
            self.turnCounter.backgroundColor = kP1Color;
        } else {
            self.turnCounter.backgroundColor = kP2Color;
        }
        self.turnCounter.text = [self.matchManager.currentTurn.number description];
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"lifePointsDetail"]){
        MatchTVC * destinationController = (MatchTVC *)segue.destinationViewController;
        destinationController.match = self.matchManager.currentMatch;
    }
}

@end
