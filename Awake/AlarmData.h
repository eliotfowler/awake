//
//  AlarmData.h
//  Awake
//
//  Created by Eliot Fowler on 7/17/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AlarmData : NSObject

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSMutableDictionary *repeatDays;
@property (strong, nonatomic) NSString *sound;
@property BOOL isSet;
@property (strong, nonatomic) NSString *repeatString;

@end
