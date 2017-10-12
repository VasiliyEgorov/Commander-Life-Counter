//
//  ManaCountersData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 30.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerInterfaceManagedObject+CoreDataClass.h"
#import "PlayerManagedObject+CoreDataClass.h"
#import "OpponentManagedObject+CoreDataClass.h"
#import "NSManagedObjectContext+Category.h"
#import "PlayerCountersManagedObject+CoreDataClass.h"
#import "CountersIndexManagedObject+CoreDataClass.h"

typedef enum : NSUInteger {
    ManaButtonOne = 0,
    ManaButtonTwo = 1,
    ManaButtonThree = 2,
    ManaButtonFour = 3,
    ManaButtonFive = 4,
    ManaButtonSix = 5,
    ManaButtonSeven = 6,
    ManaButtonEight = 7,
    ManaButtonNine = 8,
    ManaButtonTen = 9,
    ManaButtonEleven = 10,
    ManaButtonTwelve = 11,
    ManaButtonThirteen = 12,
    ManaButtonFourteen = 13,
} ManaCountersButtonTags;

typedef enum : NSUInteger {
    PlayerButtonOne = 0,
    PlayerButtonTwo = 1,
    PlayerButtonThree = 2,
    PlayerButtonFour = 3,
    PlayerButtonFive = 4,
    PlayerButtonSix = 5,
    PlayerButtonSeven = 6,
    PlayerButtonEight = 7,
} PlayerCountersButtonTags;



@interface CountersData : NSObject 

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) PlayerManagedObject *player;
@property (strong, nonatomic) OpponentManagedObject *opponent;
@property (strong, nonatomic) CountersIndexManagedObject *indexObject;

- (void) countManaWithTag:(NSInteger)tag sender:(id)sender;
- (void) countPlayerCountersWithTag:(NSInteger)tag sender:(id)sender;
- (void) getSelectedIndex:(int)index;
- (void) saveContext;

- (void) counterNameTxt:(NSString*)thirdCounterTxt fourthCounterTxt:(NSString*) fourthCounterTxt;
- (void) playerNameTxt:(NSString*)playerName;
- (void) updateThirdRowContent;
- (void) updateFourthRowContent;
- (float)rowHeight:(NSInteger)row;
- (void) refreshCounters:(id)sender;
- (void) resetAllCounters;


@end
