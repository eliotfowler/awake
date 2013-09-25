//
//  AlarmCell.h
//  Awake
//
//  Created by Eliot Fowler on 7/23/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property bool isSet;
@property (weak, nonatomic) IBOutlet UISwitch *switchOnCell;

//@property (nonatomic, weak) IBOutlet NSDate *alarmTime;

@end
