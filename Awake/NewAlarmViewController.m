//
//  NewAlarmViewController.m
//  Awake
//
//  Created by Eliot Fowler on 7/18/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "NewAlarmViewController.h"
#import "RepeatViewController.h"
#import "LabelViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface NewAlarmViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *alarmSettingsTableView;
//@property (strong, nonatomic) AlarmData* myAlarm;

@property (strong, nonatomic) NSDate *alarmTime;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableDictionary *repeatDays;
@property (strong, nonatomic) NSString *repeatString;
@property (strong, nonatomic) NSString *sound;
@property BOOL isSet;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property bool savedOrCancelled;

@end

@implementation NewAlarmViewController



- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        NSLog(@"%s", __PRETTY_FUNCTION__);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _savedOrCancelled = false;
    _alarmTime = _datePicker.date;
    self.title = @"Alarm";
    _repeatDays = [[NSMutableDictionary alloc]
                initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"monday",
                [NSNumber numberWithBool:NO], @"tuesday",
                [NSNumber numberWithBool:NO], @"wednesday",
                [NSNumber numberWithBool:NO], @"thursday",
                [NSNumber numberWithBool:NO], @"friday",
                [NSNumber numberWithBool:NO], @"saturday",
                [NSNumber numberWithBool:NO], @"sunday",
                nil];
    _sound = @"Alarm";
    _isSet = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    if(_savedOrCancelled) {
        _savedOrCancelled = false;
        _datePicker.date = [NSDate date];
        _alarmTime = _datePicker.date;
        self.title = @"Alarm";
        _repeatDays = [[NSMutableDictionary alloc]
                       initWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"monday",
                       [NSNumber numberWithBool:NO], @"tuesday",
                       [NSNumber numberWithBool:NO], @"wednesday",
                       [NSNumber numberWithBool:NO], @"thursday",
                       [NSNumber numberWithBool:NO], @"friday",
                       [NSNumber numberWithBool:NO], @"saturday",
                       [NSNumber numberWithBool:NO], @"sunday",
                       nil];
        _sound = @"Alarm";
        _isSet = YES;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        UITableViewCell *settingsCell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
        if (settingsCell == nil) {
            settingsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingsCell"];
        }
        settingsCell.textLabel.text = @"Repeat";
        settingsCell.detailTextLabel.text = @"Never";
        settingsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [settingsCell setBackgroundColor:[UIColor clearColor]];

        return settingsCell;
    } else if(indexPath.row == 1) {
        UITableViewCell *settingsCell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
        if (settingsCell == nil) {
            settingsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingsCell"];
        }
        settingsCell.textLabel.text = @"Label";
        settingsCell.detailTextLabel.text = @"Alarm";
        settingsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [settingsCell setBackgroundColor:[UIColor clearColor]];
        
        return settingsCell;
    } else if(indexPath.row == 2) {
        UITableViewCell *settingsCell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
        if (settingsCell == nil) {
            settingsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingsCell"];
        }
        settingsCell.textLabel.text = @"Sound";
        settingsCell.detailTextLabel.text = @"Alarm";
        settingsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [settingsCell setBackgroundColor:[UIColor clearColor]];
        
        return settingsCell;
    } else if(indexPath.row == 3) {
        UITableViewCell *snoozeCell = [tableView dequeueReusableCellWithIdentifier:@"snoozeCell"];
        if (snoozeCell == nil) {
            snoozeCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"snoozeCell"];
        }
        
        UISwitch *toggleSwitch = [[UISwitch alloc] init];
        snoozeCell.accessoryView = [[UIView alloc] initWithFrame:toggleSwitch.frame];
        [snoozeCell.accessoryView addSubview:toggleSwitch];
        [toggleSwitch addTarget:self action:@selector(didChangeSwitch:) forControlEvents:UIControlEventValueChanged];
        [snoozeCell setBackgroundColor:[UIColor clearColor]];
        
        snoozeCell.textLabel.text = @"Snooze";
        
        return snoozeCell;
    } else if(indexPath.row == 4) {
        UITableViewCell *settingsCell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
        if (settingsCell == nil) {
            settingsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"settingsCell"];
        }
        settingsCell.textLabel.text = @"Duration (in minutes)";
        settingsCell.detailTextLabel.text = @"5";
        settingsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        settingsCell.hidden = YES;
        settingsCell.indentationLevel = 2;
        [settingsCell setBackgroundColor:[UIColor clearColor]];
        
        return settingsCell;
    }
    
    return nil;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showRepeatView"]){
        RepeatViewController *controller = (RepeatViewController *)segue.destinationViewController;
        controller.repeatDays = _repeatDays;
        controller.delegate = self;
    } else if([segue.identifier isEqualToString:@"showLabelView"]){
        LabelViewController *controller = (LabelViewController *)segue.destinationViewController;
        controller.delegate = self;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You clicked on row %d: %@",[indexPath row], [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text]);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([indexPath row] == 0) {
        [self performSegueWithIdentifier:@"showRepeatView" sender:self];
    }
    if ([indexPath row] == 1) {
        [self performSegueWithIdentifier:@"showLabelView" sender:self];
    }
    
}

- (IBAction)didChangeSwitch:(UISwitch*)sender {
    UITableViewCell *cell = [_alarmSettingsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if(sender.on) {
        cell.hidden = NO;
    } else {
        cell.hidden = YES;
    }
}

- (IBAction)didClickCancel:(id)sender
{
    _savedOrCancelled = true;
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didClickSave:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newAlarm = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Alarm"
                                 inManagedObjectContext:context];
    
    //Here we need to get rid of the date portion of the date
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:_alarmTime];
    NSDate *timeWithoutDate = [calendar dateFromComponents:comps];
    
    [newAlarm setValue:timeWithoutDate forKey:@"date"];
    [newAlarm setValue:self.title forKey:@"title"];
    NSNumber *isSet = [NSNumber numberWithBool:_isSet];
    [newAlarm setValue:isSet forKey:@"isSet"];
    [newAlarm setValue:_sound forKey:@"sound"];
    [newAlarm setValue:_repeatString forKey:@"repeatString"];
    
    NSError *error;
    [context save:&error];
    
    [self scheduleLocalNotification];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)didFinishEditingLabel:(NSString *)label
{
    self.title = label;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *labelCell = [_alarmSettingsTableView cellForRowAtIndexPath:indexPath];
    labelCell.detailTextLabel.text = label;
}

-(void)didSetRepeatDays:(NSMutableDictionary *)repeatDays withRepeatString:(NSString *)repeatString
{
    _repeatDays = repeatDays;
    _repeatString = repeatString;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *repeatCell = [_alarmSettingsTableView cellForRowAtIndexPath:indexPath];
    repeatCell.detailTextLabel.text = _repeatString;
}

#pragma mark - UINavigatonBarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}
- (IBAction)didChangePickerValue:(id)sender {
    _alarmTime = [sender date];
}

#pragma mark - private helper methods
- (void)scheduleLocalNotification {
    NSDate* today = [NSDate date];
    // We need to schedule a local notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    bool neverRepeats = true;
    for(id key in _repeatDays) {
        if([[_repeatDays objectForKey:key] boolValue]) {
            neverRepeats = false;
            localNotification.fireDate = _alarmTime;
            localNotification.alertBody = @"Title";
            localNotification.timeZone = [NSTimeZone systemTimeZone];
            localNotification.alertAction = @"I'm up, I'm up!";
            localNotification.repeatInterval = NSWeekCalendarUnit;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
    if(neverRepeats) {
        if([_alarmTime earlierDate:today] == today) {
            localNotification.fireDate = _alarmTime;
            localNotification.alertBody = @"Title";
            localNotification.timeZone = [NSTimeZone systemTimeZone];
            localNotification.alertAction = @"I'm up, I'm up!";
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
    
}

@end
