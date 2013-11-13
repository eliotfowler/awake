//
//  AlarmCell.h
//  Awake
//
//  Created by Eliot Fowler on 7/23/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmData.h"

@interface AlarmCell : UICollectionViewCell

@property (nonatomic, strong) AlarmData* alarm;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *alarmTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchOnCell;

@end
