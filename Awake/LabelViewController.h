//
//  LabelViewController.h
//  Awake
//
//  Created by Eliot Fowler on 7/24/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LabelViewController;

@protocol LabelViewControllerDelegate;

@interface LabelViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, assign) id <LabelViewControllerDelegate> delegate;
@end

@protocol LabelViewControllerDelegate <NSObject>
@required
- (void)didFinishEditingLabel:(NSString*)label;
@end
