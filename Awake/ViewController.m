//
//  ViewController.m
//  Awake
//
//  Created by Eliot Fowler on 7/17/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "ViewController.h"
#import "NewAlarmViewController.h"
#import "AlarmCell.h"
#import "UIImage+ImageEffects.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "AlarmData.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *alarmListCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *alarmListEmptyLabel;
@property (nonatomic, strong) NSMutableArray *alarmListArray;
@property (nonatomic, strong) NewAlarmViewController* alarmController;
@property (weak, nonatomic) IBOutlet UISwitch *switchOnCell;

@property (nonatomic, strong) UINavigationController *modalNavController;

@end

@implementation ViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _alarmListArray = [NSMutableArray array];
    }
    return self;
}
- (IBAction)didClickAddButton:(id)sender {
    
    if (_modalNavController.viewControllers.count > 0)
    {
        _alarmController = (NewAlarmViewController*)_modalNavController.viewControllers[0];
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
        else
            UIGraphicsBeginImageContext(self.view.bounds.size);
        
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImage *effectImage = nil;
        effectImage = [image applyLightEffect];
        
        _alarmController.backgroundImage.image = effectImage;

            
        [self presentViewController:_modalNavController animated:YES completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_modalNavController) {
        _modalNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewAlarmViewController"];
    }
    
    [self reloadCollectionViewData];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"There was a problem: %@", error);
    }
    [_alarmListArray removeAllObjects];
    for (AlarmData *a in fetchedObjects) {
        [_alarmListArray addObject:a];
        NSLog(@"Alarm title: %@ with date: %@", a.title, a.date);
    }
    [self reloadCollectionViewData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self alarmListArray] count];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    AlarmData *alarmData = _alarmListArray[indexPath.row];
    
    double alpha = [cell isSet];
    
    cell.backgroundColor = [UIColor colorWithRed:105/255.0 green:195/255.0 blue:255/255.0 alpha:1.f];
    cell.titleLabel.text = [alarmData title];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"h:mm a"];
    cell.alarmTimeLabel.text = [dateFormatter stringFromDate:[alarmData date]];
    cell.repeatLabel.text = [alarmData repeatString];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, 80);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showRepeatView"]){
        //UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        NewAlarmViewController *controller = (NewAlarmViewController *)segue.destinationViewController;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
        else
            UIGraphicsBeginImageContext(self.view.bounds.size);
        
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        controller.backgroundImage.image = image;
    }
}

#pragma mark - Helpers

- (void)reloadCollectionViewData
{
    [_alarmListCollectionView reloadData];
    
    BOOL hasItems = [_alarmListArray count];
    
    [_alarmListCollectionView setHidden:!hasItems];
    [_alarmListEmptyLabel setHidden:hasItems];
    
}


@end
