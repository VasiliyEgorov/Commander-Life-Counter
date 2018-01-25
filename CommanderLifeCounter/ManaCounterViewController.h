//
//  ManaCounterViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CountersData.h"


@interface ManaCounterViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) CountersData *data;

@property (weak, nonatomic) IBOutlet UILabel *firstCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixthCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *seventhCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *eigthCounterLabel;

- (IBAction)counterButtons:(UIButton *)sender;
- (IBAction)changeCounterAction:(UIButton *)sender;
- (IBAction)deleteCounters:(id)sender;
- (IBAction)jumpToNoteAction:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countersViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countersViewBottomToLayoutMarginContraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopConstraint;



@end
