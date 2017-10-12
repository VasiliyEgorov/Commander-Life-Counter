//
//  PlayerCounterViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 04.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CountersData.h"
#import "PlayerCounterWithContainerController.h"

@interface PlayerCounterViewController : UITableViewController <PlayerCounterProtocol>


@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstCounterName;
@property (weak, nonatomic) IBOutlet UITextField *secondCounterName;
@property (weak, nonatomic) IBOutlet UITextField *thirdCounterNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *fourthCounterNameTxt;


@property (weak, nonatomic) IBOutlet UIButton *addThirdRow;
@property (weak, nonatomic) IBOutlet UIButton *addFourthRow;

- (IBAction)addThirdRowAction:(UIButton *)sender;
- (IBAction)addFourthRowAction:(UIButton *)sender;
- (IBAction)counterNameTxtAction:(UITextField*)sender;
- (IBAction)countersButtonsAction:(UIButton *)sender;

@property (strong, nonatomic) CountersData *data;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign, nonatomic) int counterIndex;
@property (strong, nonatomic) UITextField *playerNameTxt;

- (void) fetchCounters;

@end
