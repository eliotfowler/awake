//
//  RepeatViewController.m
//  Awake
//
//  Created by Eliot Fowler on 7/19/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "RepeatViewController.h"
#import "NewAlarmViewController.h"


@interface RepeatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mondayButton;
@property (weak, nonatomic) IBOutlet UIButton *tuesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *wednesdayButton;
@property (weak, nonatomic) IBOutlet UIButton *thursdayButton;
@property (weak, nonatomic) IBOutlet UIButton *fridayButton;
@property (weak, nonatomic) IBOutlet UIButton *saturdayButton;
@property (weak, nonatomic) IBOutlet UIButton *sundayButton;
@property (weak, nonatomic) IBOutlet UITableView *repeatTable;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;


@end

@implementation RepeatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self highlightButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickWeekday:(id)sender
{
    int tag = [sender tag];
    NSArray* weekdays = [[NSArray alloc] initWithObjects:@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday", nil];
    
    NSString* dayClicked = weekdays[tag];
    bool shouldRepeatWeekday = [[_repeatDays objectForKey:dayClicked] boolValue];
    
    [self setShouldRepeat:!shouldRepeatWeekday forDay:dayClicked];
    
    [self highlightButtons];
    [self modifyRepeatLabel];
    [_repeatTable reloadData];
    [_delegate didSetRepeatDays:_repeatDays withRepeatString:[self getShortRepeatString]];
}

- (void) highlightButtons
{
    NSArray* weekdays = [[NSArray alloc] initWithObjects:@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday", nil];
    NSArray* weekdayButtons = [[NSArray alloc] initWithObjects:_mondayButton, _tuesdayButton, _wednesdayButton, _thursdayButton, _fridayButton, _saturdayButton, _sundayButton, nil];
    
    for(int i=0; i<[weekdays count]; i++) {
        NSString* key = weekdays[i];
        UIButton* button = weekdayButtons[i];
        double alpha = [[_repeatDays objectForKey:key] boolValue] ? .8 : .2;
        
        UIColor* newColor = [[button backgroundColor] colorWithAlphaComponent:alpha];
        [button setBackgroundColor:newColor];
    }
}

- (void) modifyRepeatLabel
{
    NSArray* weekdays = [[NSArray alloc] initWithObjects:@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday", nil];
    
    //First check if will repeat all days
    if(_willRepeatEveryday) {
        [_repeatLabel setText:@"Repeats every day."];
    } else if(_willRepeatWeekdays) {
        [_repeatLabel setText:@"Repeats on weekdays."];
    } else if(_willRepeatWeekends) {
        [_repeatLabel setText:@"Repeats on weekends."];
    } else {
        NSString *newLabelText = @"Repeats on";
        NSMutableArray *daysAlarmWillRepeat = [[NSMutableArray alloc] init];
        //Find all weekdays that this will repeat on
        for(int i=0; i<[weekdays count]; i++) {
            NSString* key = weekdays[i];
            if([[_repeatDays objectForKey:key] boolValue]) {
                [daysAlarmWillRepeat addObject:[weekdays objectAtIndex:i]];
            }
        }
        //If there are no days that this repeats
        if([daysAlarmWillRepeat count] == 0) {
            newLabelText = @"Never repeats.";
        }
        //If it only repeats one day
        else if([daysAlarmWillRepeat count] == 1) {
            newLabelText = [NSString stringWithFormat:@"Repeats on %@.",[daysAlarmWillRepeat objectAtIndex:0]];
        }
        //If it repeats 2 days, just connect with and
        else if([daysAlarmWillRepeat count] == 2) {
            newLabelText = [NSString stringWithFormat:@"Repeats on %@ and %@.",[daysAlarmWillRepeat objectAtIndex:0], [daysAlarmWillRepeat objectAtIndex:1]];
        }
        //Otherwise, it gets tricky
        else {
            NSString *formatString = [daysAlarmWillRepeat objectAtIndex:0];
            for (int i=1; i<daysAlarmWillRepeat.count-1; i++) {
                formatString = [NSString stringWithFormat:@"%@, %@", formatString, [daysAlarmWillRepeat objectAtIndex:i]];
            }
            formatString = [NSString stringWithFormat:@"%@ and %@.", formatString, [daysAlarmWillRepeat objectAtIndex:[daysAlarmWillRepeat count]-1]];
            newLabelText = [NSString stringWithFormat:@"Repeats %@", formatString];
        }
        
        [_repeatLabel setText:newLabelText];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == 0) {
        UITableViewCell *everydayCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (everydayCell == nil) {
            everydayCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        everydayCell.textLabel.text = @"Every Day";
        if(_willRepeatEveryday) {
            [everydayCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [everydayCell setAccessoryType:UITableViewCellAccessoryNone];
        }
        return everydayCell;
    } else if([indexPath row] == 1) {
        UITableViewCell *weekdaysCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (weekdaysCell == nil) {
            weekdaysCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        weekdaysCell.textLabel.text = @"Weekdays Only";
        if(_willRepeatWeekdays) {
            [weekdaysCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [weekdaysCell setAccessoryType:UITableViewCellAccessoryNone];
        }
        return weekdaysCell;
    } else {
        UITableViewCell *weekendsCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (weekendsCell == nil) {
            weekendsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        weekendsCell.textLabel.text = @"Weekends Only";
        if(_willRepeatWeekends) {
            [weekendsCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        } else {
            [weekendsCell setAccessoryType:UITableViewCellAccessoryNone];
        }
        return weekendsCell;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == 0) {
        [self setShouldRepeatEveryday:!_willRepeatEveryday];
    } else if([indexPath row] == 1) {
        [self setShouldRepeatOnWeekdays:!_willRepeatWeekdays];
    } else if([indexPath row] == 2) {
        [self setShouldRepeatOnWeekends:!_willRepeatWeekends];
    }
    
    [tableView reloadData];
    [self highlightButtons];
    [self modifyRepeatLabel];
    [_delegate didSetRepeatDays:_repeatDays withRepeatString:[self getShortRepeatString]];
}

#pragma repeatMethods

- (void) setShouldRepeat:(BOOL)shouldRepeat forDay:(NSString*)day
{
    [_repeatDays setObject:[NSNumber numberWithBool:shouldRepeat] forKey:day];
    
    bool shouldRepeatMonday = [[_repeatDays objectForKey:@"monday"] boolValue];
    bool shouldRepeatTuesday = [[_repeatDays objectForKey:@"tuesday"] boolValue];
    bool shouldRepeatWednesday = [[_repeatDays objectForKey:@"wednesday"] boolValue];
    bool shouldRepeatThursday = [[_repeatDays objectForKey:@"thursday"] boolValue];
    bool shouldRepeatFriday = [[_repeatDays objectForKey:@"friday"] boolValue];
    bool shouldRepeatSaturday = [[_repeatDays objectForKey:@"saturday"] boolValue];
    bool shouldRepeatSunday = [[_repeatDays objectForKey:@"sunday"] boolValue];
    
    _willRepeatWeekdays = NO;
    _willRepeatEveryday = NO;
    _willRepeatWeekends = NO;
    
    if(shouldRepeatMonday &&
       shouldRepeatTuesday &&
       shouldRepeatWednesday &&
       shouldRepeatThursday &&
       shouldRepeatFriday &&
       !shouldRepeatSaturday &&
       !shouldRepeatSunday) {
        _willRepeatWeekdays = YES;
    }
    
    if(!shouldRepeatMonday &&
       !shouldRepeatTuesday &&
       !shouldRepeatWednesday &&
       !shouldRepeatThursday &&
       !shouldRepeatFriday &&
       shouldRepeatSaturday &&
       shouldRepeatSunday) {
        _willRepeatWeekends = YES;
    }
    
    if(shouldRepeatMonday &&
       shouldRepeatTuesday &&
       shouldRepeatWednesday &&
       shouldRepeatThursday &&
       shouldRepeatFriday &&
       shouldRepeatSaturday &&
       shouldRepeatSunday) {
        _willRepeatEveryday = YES;
    }
}

- (void) setShouldRepeatOnWeekdays:(BOOL)shouldRepeat
{
    NSArray* weekdays = [[NSArray alloc] initWithObjects:@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", nil];
    for(NSString* day in weekdays) {
        [_repeatDays setObject:[NSNumber numberWithBool:shouldRepeat] forKey:day];
    }
    if(shouldRepeat) {
        [_repeatDays setObject:[NSNumber numberWithBool:NO] forKey:@"saturday"];
        [_repeatDays setObject:[NSNumber numberWithBool:NO] forKey:@"sunday"];
    }
    _willRepeatWeekdays = shouldRepeat;
    _willRepeatWeekends = NO;
    _willRepeatEveryday = NO;
}

- (void) setShouldRepeatOnWeekends:(BOOL)shouldRepeat
{
    NSArray* weekdays = [[NSArray alloc] initWithObjects:@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", nil];
    NSArray* weekends = [[NSArray alloc] initWithObjects:@"saturday", @"sunday", nil];
    for(NSString* day in weekends) {
        [_repeatDays setObject:[NSNumber numberWithBool:shouldRepeat] forKey:day];
    }
    if(shouldRepeat) {
        for(NSString* day in weekdays) {
            [_repeatDays setObject:[NSNumber numberWithBool:NO] forKey:day];
        }
    }
    _willRepeatWeekends = shouldRepeat;
    _willRepeatWeekdays = NO;
    _willRepeatEveryday = NO;
}

- (void) setShouldRepeatEveryday:(BOOL)shouldRepeat
{
    NSArray* days = [[NSArray alloc] initWithObjects:@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday", nil];
    for(NSString* day in days) {
        [_repeatDays setObject:[NSNumber numberWithBool:shouldRepeat] forKey:day];
    }
    
    _willRepeatEveryday = shouldRepeat;
    _willRepeatWeekends = NO;
    _willRepeatWeekdays = NO;
}

- (NSString*) getShortRepeatString
{
    if(_willRepeatEveryday) {
        return @"Everyday";
    }
    else if(_willRepeatWeekdays) {
        return @"Weekdays";
    } else if(_willRepeatWeekends) {
        return @"Weekends";
    } else {
        NSString* repeatDaysString = @"";
        if([[_repeatDays objectForKey:@"monday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"M "];
        }
        if([[_repeatDays objectForKey:@"tuesday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"T "];
        }
        if([[_repeatDays objectForKey:@"wednesday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"W "];
        }
        if([[_repeatDays objectForKey:@"thursday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"R "];
        }
        if([[_repeatDays objectForKey:@"friday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"F "];
        }
        if([[_repeatDays objectForKey:@"saturday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"Sa "];
        }
        if([[_repeatDays objectForKey:@"sunday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"Su "];
        }
        return repeatDaysString;
    }
}


@end
