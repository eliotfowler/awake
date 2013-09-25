//
//  LabelViewController.m
//  Awake
//
//  Created by Eliot Fowler on 7/24/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "LabelViewController.h"

@interface LabelViewController ()
@property (weak, nonatomic) IBOutlet UITextField *alarmLabelTextField;

@end

@implementation LabelViewController

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
    [_alarmLabelTextField becomeFirstResponder];
}
- (IBAction)alarmTitleChanged:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didFinishEditingLabel:)])
    {
        [_delegate didFinishEditingLabel:[_alarmLabelTextField text]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
