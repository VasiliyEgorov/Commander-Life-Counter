//
//  ManaCounterViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "ManaCounterViewController.h"
#import "DataManager.h"
#import "NSManagedObjectContext+Category.h"
#import "PlayerCounterWithContainerController.h"
#import "Constants.h"

@interface ManaCounterViewController ()

@end

@implementation ManaCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initLeftSwipes];
    [self controllerSettings];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self fetchCounters];
    
}

- (void) controllerSettings {
    
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationItem setTitle:@"Mana Counters"];
    [self changeConstraints];
}

- (void) changeConstraints {
    
    float h = [UIScreen mainScreen].bounds.size.height;
    
    if (h == IPHONE_5) {
        
        self.btnTopConstraint.constant = 6;
        self.countersViewLeadingConstraint.constant = 24;
        self.countersViewBottomToLayoutMarginContraint.constant = 71;
    }
    if (h == IPHONE_6_7_PLUS || h == IPHONE_X) {
        
        self.countersViewLeadingConstraint.constant = 7;
    }
    
    [self.view updateConstraintsIfNeeded];
}

- (CountersData*)data {
    
    PlayerCounterWithContainerController *containerController = (PlayerCounterWithContainerController*)[[(UINavigationController*)[[self.tabBarController viewControllers]
                                                                                                                                   objectAtIndex:0]
                                                                                                                                    viewControllers]
                                                                                                                                    objectAtIndex:0];
    _data = containerController.dataForManaCounters;
    
    return _data;
}



- (NSManagedObjectContext*)managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [DataManager sharedManager].mainQueueContext;
    }
    return  _managedObjectContext;
    
}
#pragma mark - Swipes

- (void) initLeftSwipes {
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:leftSwipe];
    
}



- (void) handleLeftSwipe:(UISwipeGestureRecognizer*) recognizer {
    
    self.tabBarController.selectedIndex = 0;
}


#pragma mark - Actions


- (IBAction)counterButtons:(UIButton *)sender {
    
    [self.data countManaWithTag:sender.tag sender:self];
   
    [self fetchCounters];
}

- (IBAction)changeCounterAction:(UIButton *)sender {
    [self handleLeftSwipe:nil];
}

- (IBAction)deleteCounters:(id)sender {
    
    [self.data refreshCounters:self];
    [self fetchCounters];
}

- (IBAction)jumpToNoteAction:(UIBarButtonItem *)sender {
    
    self.tabBarController.selectedIndex = 2;
}

#pragma mark - Fetch/ManagedObjectContext

- (void) fetchCounters {
  
    ManaCountersManagedObject *object = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"ManaCountersManagedObject"];
 
            self.firstCounterLabel.text = [NSString stringWithFormat:@"%d", object.manaFirstCounter];
            self.secondCounterLabel.text = [NSString stringWithFormat:@"%d", object.manaSecondCounter];
            self.thirdCounterLabel.text = [NSString stringWithFormat:@"%d", object.manaThirdCounter];
            self.fourthCounterLabel.text = [NSString stringWithFormat:@"%d", object.manaFourthCounter];
            self.fifthCounterLabel.text = [NSString stringWithFormat:@"%d", object.manaFifthCounter];
            self.sixthCounterLabel.text = [NSString stringWithFormat:@"%d", object.manaSixthCounter];
            self.seventhCounterLabel.text = [NSString stringWithFormat:@"%d", object.manaSeventhCounter];

}




@end
