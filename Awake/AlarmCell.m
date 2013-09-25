//
//  AlarmCell.m
//  Awake
//
//  Created by Eliot Fowler on 7/23/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "AlarmCell.h"

@implementation AlarmCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSet = YES;
        [_switchOnCell setOn:_isSet];
        // Initialization code
    }
    return self;
}
- (IBAction)switchWasSwitched:(id)sender {
    float alpha = [sender isOn] ? 1 : .3;
    [self setBackgroundColor:[[self backgroundColor] colorWithAlphaComponent:alpha]];
    _isSet = [sender isOn];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
@end
