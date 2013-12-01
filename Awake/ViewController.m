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

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *alarmListCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *alarmListEmptyLabel;
@property (nonatomic, strong) NSMutableArray *alarmListArray;
@property (nonatomic, strong) NewAlarmViewController* alarmController;
@property (weak, nonatomic) IBOutlet UISwitch *switchOnCell;

@property (nonatomic, strong) UINavigationController *modalNavController;

@end

@implementation ViewController {
    NSFetchedResultsController* fetchedResultsController;
}


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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Alarm" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    fetchedResultsController = [[NSFetchedResultsController alloc]
                                initWithFetchRequest:fetchRequest
                                managedObjectContext:context
                                sectionNameKeyPath:nil
                                cacheName:nil];
    
    fetchedResultsController.delegate = self;
    
    NSError *error;
    BOOL success = [fetchedResultsController performFetch:&error];
    if(!success) {
        NSLog(@"There was ab error fetching data: %@", error);
    }
    [self reloadCollectionViewData];
    _modalNavController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewAlarmViewController"];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
                                                                atIndexPath:(NSIndexPath *)indexPath
                                                              forChangeType:(NSFetchedResultsChangeType)type
                                                               newIndexPath:(NSIndexPath *)newIndexPath {
    UICollectionView* collectionView = self.alarmListCollectionView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            NSLog(@"Inserting fetched result");
            [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"Deleting fetched result");
            [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            break;
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"Updating fetched result");
            break;
            
        case NSFetchedResultsChangeMove:
            NSLog(@"Moving fetched result");
            [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
            [collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
            break;
    }
    
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [[fetchedResultsController sections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([[fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AlarmCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSManagedObject *managedObject = [fetchedResultsController objectAtIndexPath:indexPath];

    BOOL isSet = [(NSNumber*)[managedObject valueForKey:@"isSet"] boolValue];
    NSString* title = [managedObject valueForKey:@"title"];
    NSDate* date = [managedObject valueForKey:@"date"];
    NSString* repeatString = [managedObject valueForKey:@"repeatString"];
    
    CGFloat alpha = isSet ? 1.0f : 0.3f;
    cell.backgroundColor = [UIColor colorWithRed:105/255.0 green:195/255.0 blue:255/255.0 alpha:alpha];
    [cell.switchOnCell setOn:isSet];
    cell.titleLabel.text = title;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"h:mm a"];
    cell.alarmTimeLabel.text = [dateFormatter stringFromDate:date];
    cell.repeatLabel.text = repeatString;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, 80);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showRepeatView"]){
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

- (IBAction)switchWasSwitched:(id)sender {
    UISwitch* alarmSwitch = (UISwitch *)sender;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.alarmListCollectionView];
    NSIndexPath* indexPath = [self.alarmListCollectionView indexPathForItemAtPoint:buttonPosition];
    NSManagedObject* managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    NSNumber* isOnNumber = [NSNumber numberWithBool:[alarmSwitch isOn]];
    [managedObject setValue:isOnNumber forKey:@"isSet"];
    
    NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    AlarmCell* cell = (AlarmCell*)[self.alarmListCollectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [cell.backgroundColor colorWithAlphaComponent:[alarmSwitch isOn] ? 1.0f : 0.3f];
}

#pragma mark - Helpers

- (void)reloadCollectionViewData
{
    [_alarmListCollectionView reloadData];
    
    BOOL hasItems = [[fetchedResultsController fetchedObjects] count] > 0;
    
    [_alarmListCollectionView setHidden:!hasItems];
    [_alarmListEmptyLabel setHidden:hasItems];
}


@end
