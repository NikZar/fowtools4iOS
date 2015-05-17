//
//  TimerVC.m
//  ForceOfWill
//
//  Created by Niko Zarzani on 4/25/15.
//  Copyright (c) 2015 IndieZiOS. All rights reserved.
//

#import "TimerVC.h"
#import "Constants.h"
#import "DACircularProgressView.h"

@interface TimerVC()

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;

@property (weak, nonatomic) IBOutlet UILabel *settingsLabel;

@property (strong, nonatomic) NSDate *endDate;

@property (strong, nonatomic) NSNumber *minutesTurnDuration;

@property (strong, nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet DACircularProgressView *progressView;

@end

@implementation TimerVC

#pragma mark - NSUserDefaults properties

-(NSDate *)endDate
{
    NSDate *endDate = [[NSUserDefaults standardUserDefaults] valueForKey: kTimerEndDate];
    return endDate ? endDate : [NSDate distantPast];
}

-(void)setEndDate:(NSDate *)endDate
{
    [[NSUserDefaults standardUserDefaults] setValue:endDate forKey:kTimerEndDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSNumber *)minutesTurnDuration
{
    NSNumber * minutesTurnDuration = [[NSUserDefaults standardUserDefaults] valueForKey: kTurnDuration];
    return minutesTurnDuration ? minutesTurnDuration : @60;
}

-(void)setMinutesTurnDuration:(NSNumber * )minutesTurnDuration
{
    [[NSUserDefaults standardUserDefaults] setValue:minutesTurnDuration forKey:kTurnDuration];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Navigation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateSettingLabel];
    
    self.progressView.roundedCorners = NO;
    self.progressView.trackTintColor = [UIColor redColor];
    self.progressView.progressTintColor = kP1Color;
    self.progressView.thicknessRatio = 0.7f;
    self.progressView.clockwiseProgress = YES;
    
    NSInteger secondsToEnd = ((NSInteger)[self.endDate timeIntervalSinceNow]);
    if(secondsToEnd < 0){
        [self.progressView setProgress:0.f animated:NO];
        [self resetTimerLabel];
    } else {
        [self startTimerUpdateUI];
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopTimer];
    });
}

- (void)updateSettingLabel
{
    NSInteger secondsToEnd = ((NSInteger)[self.endDate timeIntervalSinceNow]);
    
    if (secondsToEnd < 0) {
        [self resetTimerLabel];
    }
    self.settingsLabel.text = [NSString stringWithFormat:@"%@ minutes", self.minutesTurnDuration];
}

- (IBAction)decrementTimer:(id)sender {
    NSNumber * newTurnDuration = [NSNumber numberWithInt:([self.minutesTurnDuration intValue] -1)];
    if (![newTurnDuration isEqualToNumber:[NSNumber numberWithInt:0]]) {
        [[NSUserDefaults standardUserDefaults] setValue:newTurnDuration forKey:kTurnDuration];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updateSettingLabel];
    }
}

- (IBAction)incrementTimer:(id)sender {
    NSNumber * newTurnDuration = [NSNumber numberWithInt:([self.minutesTurnDuration intValue] +1)];
    [[NSUserDefaults standardUserDefaults] setValue:newTurnDuration forKey:kTurnDuration];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self updateSettingLabel];
}

- (IBAction)stopCountdown:(id)sender {
    
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];
    
    if ([oldNotifications count] > 0){
        [app cancelAllLocalNotifications];
    }
    
    [self resetTimerLabel];
    
    [self.progressView setProgress:0.f animated:YES];
    
    self.endDate = [NSDate distantPast];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopTimer];
    });
}

- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (IBAction)startCountdown:(id)sender {
    [self.progressView setProgress:1.0f animated:NO];
    //Remove the time component from the datePicker.  We care only about the date
    self.endDate = [[NSDate alloc] initWithTimeIntervalSinceNow: [self.minutesTurnDuration intValue]*60];
    
    UIApplication* app = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [app scheduledLocalNotifications];

    if ([oldNotifications count] > 0){
        [app cancelAllLocalNotifications];
    }
    
    
    NSDate *alertTime = self.endDate;
    UIApplication* application = [UIApplication sharedApplication];
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.repeatInterval = NSDayCalendarUnit;
    [notification setAlertBody:@"Timer elapsed!"];
    [notification setFireDate:alertTime];
    [notification setTimeZone:[NSTimeZone  defaultTimeZone]];
    [application setScheduledLocalNotifications:[NSArray arrayWithObject:notification]];
    
    
    [self startTimerUpdateUI];
    
}

-(void)startTimerUpdateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopTimer];
        //Set up a timer that calls the updateTime method every second to update the label
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime)
                                                    userInfo:nil
                                                     repeats:YES];
    });
}

- (void)resetTimerLabel
{
    NSInteger secondsToEnd = [self.minutesTurnDuration intValue] * 60;
    NSInteger seconds = secondsToEnd % 60;
    NSInteger minutes = (secondsToEnd / 60) % 60;
    NSInteger hours = (secondsToEnd / 3600) % 24;
    
    //Update the label with the remaining time
    self.countdownLabel.text = [NSString stringWithFormat:@"%ld h %ld m %ld s", (long)hours, (long)minutes, (long)seconds];
}

-(void)updateTime
{
    //Get the time left until the specified date
    NSInteger secondsToEnd = ((NSInteger)[self.endDate timeIntervalSinceNow]);
    
    if(secondsToEnd >= 0){
        NSInteger seconds = secondsToEnd % 60;
        NSInteger minutes = (secondsToEnd / 60) % 60;
        NSInteger hours = (secondsToEnd / 3600) % 24;
        
        //Update the label with the remaining time
        self.countdownLabel.text = [NSString stringWithFormat:@"%ld h %ld m %ld s", (long)hours, (long)minutes, (long)seconds];
        
        NSNumber * turnDuration = [[NSUserDefaults standardUserDefaults] valueForKey: kTurnDuration];
        CGFloat progress = (CGFloat)secondsToEnd / (CGFloat)([turnDuration integerValue]*60);
        [self.progressView setProgress:progress animated:YES];
        
        if (self.progressView.progress > 1.0f && [self.timer isValid]) {
            
            [self resetTimerLabel];
            
            [self.progressView setProgress:0.f animated:YES];
            
            self.endDate = [NSDate distantPast];
        }

    }
    else {
        [self stopCountdown:nil];
    }
   
}

@end
