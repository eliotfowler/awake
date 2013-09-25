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
    [_repeatTable reloadData];
    [_delegate didSetRepeatDays:_repeatDays withRepeatString:[self getRepeatString]];
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
    [_delegate didSetRepeatDays:_repeatDays withRepeatString:[self getRepeatString]];
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

- (NSString*) getRepeatString
{
    if(_willRepeatEveryday) {
        return @"Repeats everyday";
    }
    else if(_willRepeatWeekdays) {
        return @"Repeats weekdays";
    } else if(_willRepeatWeekends) {
        return @"Repeats weekends";
    } else {
        NSString* repeatDaysString = @"";
        if([[_repeatDays objectForKey:@"monday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"M"];
        }
        if([[_repeatDays objectForKey:@"tuesday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"T"];
        }
        if([[_repeatDays objectForKey:@"wednesday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"W"];
        }
        if([[_repeatDays objectForKey:@"thursday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"R"];
        }
        if([[_repeatDays objectForKey:@"friday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"F "];
        }
        if([[_repeatDays objectForKey:@"saturday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"Sa "];
        }
        if([[_repeatDays objectForKey:@"sunday"] boolValue]) {
            repeatDaysString = [repeatDaysString stringByAppendingString:@"Su"];
        }
        return repeatDaysString;
    }
}


@end
