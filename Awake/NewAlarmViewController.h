//
//  NewAlarmViewController.h
//  Awake
//
//  Created by Eliot Fowler on 7/18/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelViewController.h"
#import "RepeatViewController.h"

@interface NewAlarmViewController : UIViewController <LabelViewControllerDelegate, RepeatViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@end
