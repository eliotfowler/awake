//
//  RepeatViewController.h
//  Awake
//
//  Created by Eliot Fowler on 7/19/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RepeatViewController;

@protocol RepeatViewControllerDelegate;

@interface RepeatViewController : UIViewController
@property (strong, nonatomic) NSMutableDictionary *repeatDays;
@property BOOL willRepeatWeekdays;
@property BOOL willRepeatWeekends;
@property BOOL willRepeatEveryday;
@property (strong, nonatomic) id <RepeatViewControllerDelegate> delegate;
//@property (weak, nonatomic) AlarmData* myAlarm;

@end

@protocol RepeatViewControllerDelegate <NSObject>

@required
- (void)didSetRepeatDays:(NSMutableDictionary *)repeatDays withRepeatString:(NSString *) repeatString;

@end
