//
//  ManaCountersData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 30.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CountersData.h"
#import "DataManager.h"
#import "ManaCounterViewController.h"
#import "PlayerCounterViewController.h"
#import "PlayerCountersInterfaceLogic.h"


@interface CountersData ()

@property (strong, nonatomic) PlayerCountersInterfaceLogic *counterInterfaceLogic;

@end

@implementation CountersData

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (!self.player) {
            self.player.counters.firstCounter = 20;
        }
        if (!self.opponent) {
            self.opponent.counter.firstCounter = 20;
        }
 
    }
    return self;
}


- (PlayerCountersInterfaceLogic*) counterInterfaceLogic {
    if (!_counterInterfaceLogic) {
        _counterInterfaceLogic = [[PlayerCountersInterfaceLogic alloc] init];
    }
    return _counterInterfaceLogic;
}


- (NSManagedObjectContext*) managedObjectContext {

    if (!_managedObjectContext) {
        _managedObjectContext = [DataManager sharedManager].mainQueueContext;
    }
    return  _managedObjectContext;
}


- (PlayerManagedObject*) player {
    
    _player = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"PlayerManagedObject"];
    
    if (!_player) {
        
       _player = [[PlayerManagedObject alloc] initWithContext:self.managedObjectContext];
        [self configurePlayerRelations:_player];
    }
    
    return _player;
}

- (OpponentManagedObject*) opponent {
    
    _opponent = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"OpponentManagedObject"];
    
    if (!_opponent) {
        
        _opponent = [[OpponentManagedObject alloc] initWithContext:self.managedObjectContext];
        [self configureOpponentRelations:_opponent];
    }
    
    return _opponent;
}

- (CountersIndexManagedObject*) indexObject {
    
    _indexObject = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"CountersIndexManagedObject"];
    
    if (!_indexObject) {
        _indexObject = [[CountersIndexManagedObject alloc] initWithContext:self.managedObjectContext];
    }
    return _indexObject;
}

#pragma mark - PlayerCountersInterfaceLogic

- (void) counterNameTxt:(NSString*)thirdCounterTxt fourthCounterTxt:(NSString*) fourthCounterTxt {
    [self.counterInterfaceLogic counterNameTxt:thirdCounterTxt fourthCounterTxt:fourthCounterTxt];
}

- (void) playerNameTxt:(NSString*)playerName {
    [self.counterInterfaceLogic playerNameTxt:playerName];
}
- (void) updateThirdRowContent {
    [self.counterInterfaceLogic updateThirdRowContent];
}
- (void) updateFourthRowContent {
    [self.counterInterfaceLogic updateFourthRowContent];
}
- (float)rowHeight:(NSInteger)row {
    return [self.counterInterfaceLogic rowHeight:row];
}


#pragma mark - CountersCalcs

- (void) countManaWithTag:(NSInteger)tag sender:(id)sender {
    
    
    if ([sender isKindOfClass:[ManaCounterViewController class]]) {
       
        switch (tag) {
            case ManaButtonOne:
                self.player.counters.manaCounter.manaFirstCounter = self.player.counters.manaCounter.manaFirstCounter + 1;
                break;
            case ManaButtonTwo:
                self.player.counters.manaCounter.manaSecondCounter = self.player.counters.manaCounter.manaSecondCounter + 1;
                break;
            case ManaButtonThree:
                self.player.counters.manaCounter.manaThirdCounter = self.player.counters.manaCounter.manaThirdCounter + 1;
                break;
            case ManaButtonFour:
                self.player.counters.manaCounter.manaFourthCounter = self.player.counters.manaCounter.manaFourthCounter + 1;
                break;
            case ManaButtonFive:
                self.player.counters.manaCounter.manaFifthCounter = self.player.counters.manaCounter.manaFifthCounter + 1;
                break;
            case ManaButtonSix:
                self.player.counters.manaCounter.manaSixthCounter = self.player.counters.manaCounter.manaSixthCounter + 1;
                break;
            case ManaButtonSeven:
                self.player.counters.manaCounter.manaSeventhCounter = self.player.counters.manaCounter.manaSeventhCounter + 1;
                break;
            case ManaButtonEight:
                self.player.counters.manaCounter.manaFirstCounter = [self countDownWithFilter:self.player.counters.manaCounter.manaFirstCounter sender:sender];
                break;
            case ManaButtonNine:
                self.player.counters.manaCounter.manaSecondCounter = [self countDownWithFilter:self.player.counters.manaCounter.manaSecondCounter sender:sender];
                break;
            case ManaButtonTen:
                self.player.counters.manaCounter.manaThirdCounter = [self countDownWithFilter:self.player.counters.manaCounter.manaThirdCounter sender:sender];
                break;
            case ManaButtonEleven:
                self.player.counters.manaCounter.manaFourthCounter = [self countDownWithFilter:self.player.counters.manaCounter.manaFourthCounter sender:sender];
                break;
            case ManaButtonTwelve:
                self.player.counters.manaCounter.manaFifthCounter = [self countDownWithFilter:self.player.counters.manaCounter.manaFifthCounter sender:sender];
                break;
            case ManaButtonThirteen:
                self.player.counters.manaCounter.manaSixthCounter = [self countDownWithFilter:self.player.counters.manaCounter.manaSixthCounter sender:sender];
                break;
            case ManaButtonFourteen:
                self.player.counters.manaCounter.manaSeventhCounter = [self countDownWithFilter:self.player.counters.manaCounter.manaSeventhCounter sender:sender];
                break;
                
            default:
                break;
    }
    
}
    
        [self saveContext];
}

- (void) countPlayerCountersWithTag:(NSInteger)tag sender:(id)sender {
    
    if ([sender isKindOfClass:[PlayerCounterViewController class]]) {
        if (self.indexObject.index == 0) {
            
            switch (tag) {
                case PlayerButtonOne:
                    self.player.counters.firstCounter = self.player.counters.firstCounter + 1;
                    break;
                case PlayerButtonTwo:
                    self.player.counters.secondCounter = [self countUpWithFilter:self.player.counters.secondCounter];
                    break;
                case PlayerButtonThree:
                    self.player.counters.thirdCounter = self.player.counters.thirdCounter + 1;
                    break;
                case PlayerButtonFour:
                    self.player.counters.fourthCounter = self.player.counters.fourthCounter + 1;
                    break;
                case PlayerButtonFive:
                    self.player.counters.firstCounter = self.player.counters.firstCounter - 1;
                    break;
                case PlayerButtonSix:
                    self.player.counters.secondCounter = [self countDownWithFilter:self.player.counters.secondCounter sender:sender];
                    break;
                case PlayerButtonSeven:
                    self.player.counters.thirdCounter = [self countDownWithFilter:self.player.counters.thirdCounter sender:sender];
                    break;
                case PlayerButtonEight:
                    self.player.counters.fourthCounter = [self countDownWithFilter:self.player.counters.fourthCounter sender:sender];
                    break;
                default:
                    break;
            }
        } else {
            
            switch (tag) {
                case PlayerButtonOne:
                    self.opponent.counter.firstCounter = self.opponent.counter.firstCounter + 1;
                    break;
                case PlayerButtonTwo:
                    self.opponent.counter.secondCounter = [self countUpWithFilter:self.opponent.counter.secondCounter];;
                    break;
                case PlayerButtonThree:
                    self.opponent.counter.thirdCounter = self.opponent.counter.thirdCounter + 1;
                    break;
                case PlayerButtonFour:
                    self.opponent.counter.fourthCounter = self.opponent.counter.fourthCounter + 1;
                    break;
                case PlayerButtonFive:
                    self.opponent.counter.firstCounter = self.opponent.counter.firstCounter - 1;
                    break;
                case PlayerButtonSix:
                    self.opponent.counter.secondCounter = [self countDownWithFilter:self.opponent.counter.secondCounter sender:sender];
                    break;
                case PlayerButtonSeven:
                    self.opponent.counter.thirdCounter = [self countDownWithFilter:self.opponent.counter.thirdCounter sender:sender];
                    break;
                case PlayerButtonEight:
                    self.opponent.counter.fourthCounter = [self countDownWithFilter:self.opponent.counter.fourthCounter sender:sender];
                    break;
                default:
                    break;
            }

        }
    }

    [self saveContext];
}

- (void) getSelectedIndex:(int)index {
    
        self.indexObject.index = index;
    
    [self saveContext];
}

#pragma mark - Init/Delete ManagedObjects

- (void) configurePlayerRelations:(PlayerManagedObject*)player {
    
    if (player) {

    UIImage *img = [UIImage imageNamed:@"caret-down.png"];
    NSData *data = UIImagePNGRepresentation(img);
    
    
    PlayerCountersManagedObject *counters = [[PlayerCountersManagedObject alloc] initWithContext:self.managedObjectContext];
    ManaCountersManagedObject *mana = [[ManaCountersManagedObject alloc] initWithContext:self.managedObjectContext];
    PlayerInterfaceManagedObject *interface = [[PlayerInterfaceManagedObject alloc] initWithContext:self.managedObjectContext];
    interface.addThirdRowButtonImage = data;
    interface.addFourthRowButtonImage = data;
    player.counters = counters;
    player.counters.interface = interface;
    player.counters.manaCounter = mana;

        [self saveContext];
    }
}

- (void) configureOpponentRelations:(OpponentManagedObject*)opponent {
    
    if (opponent) {
        
    UIImage *img = [UIImage imageNamed:@"caret-down.png"];
    NSData *data = UIImagePNGRepresentation(img);
    
    
    PlayerCountersManagedObject *counters = [[PlayerCountersManagedObject alloc] initWithContext:self.managedObjectContext];
    PlayerInterfaceManagedObject *interface = [[PlayerInterfaceManagedObject alloc] initWithContext:self.managedObjectContext];
    interface.addThirdRowButtonImage = data;
    interface.addFourthRowButtonImage = data;
    opponent.counter = counters;
    opponent.counter.interface = interface;
    
    [self saveContext];
    }
}



#pragma mark - RefreshCounters

- (void) refreshCounters:(id)sender {
    
    if ([sender isKindOfClass:[PlayerCounterViewController class]]) {
        
        if (self.indexObject.index == 0) {
            
            self.player.counters.firstCounter = 20;
            self.player.counters.secondCounter = 0;
            self.player.counters.thirdCounter = 0;
            self.player.counters.fourthCounter = 0;
        } else {
            
            self.opponent.counter.firstCounter = 20;
            self.opponent.counter.secondCounter = 0;
            self.opponent.counter.thirdCounter = 0;
            self.opponent.counter.fourthCounter = 0;
        }
    }
    else {
        self.player.counters.manaCounter.manaFirstCounter = 0;
        self.player.counters.manaCounter.manaSecondCounter = 0;
        self.player.counters.manaCounter.manaThirdCounter = 0;
        self.player.counters.manaCounter.manaFourthCounter = 0;
        self.player.counters.manaCounter.manaFifthCounter = 0;
        self.player.counters.manaCounter.manaSeventhCounter = 0;
        self.player.counters.manaCounter.manaSixthCounter = 0;
    }
    [self saveContext];
}

- (void) resetAllCounters {
   
    NSArray *mainCountersArray = [self.managedObjectContext obtainArrayOfManagedObjectsWithEntityName:@"PlayerCountersManagedObject" andPredicate:nil];
    
    if (mainCountersArray) {
        
    for (PlayerCountersManagedObject *object in mainCountersArray) {
        [self.managedObjectContext deleteObject:object];
    }
    }
    
    NSArray *interfaceArray = [self.managedObjectContext obtainArrayOfManagedObjectsWithEntityName:@"PlayerInterfaceManagedObject" andPredicate:nil];
    
    if (interfaceArray) {
    
    for (PlayerInterfaceManagedObject *object in interfaceArray) {
        [self.managedObjectContext deleteObject:object];
    }
    }
    
    ManaCountersManagedObject *object = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"ManaCountersManagedObject"];
    
    if (object) {
        
    [self.managedObjectContext deleteObject:object];
    }
    
    self.indexObject.index = 0;
    
    [self saveContext];
    
    [self configurePlayerRelations:self.player];
    [self configureOpponentRelations:self.opponent];
}


#pragma mark - Private Methods

- (int) countDownWithFilter:(int) number sender:(id)sender {
    if (([sender isKindOfClass:[ManaCounterViewController class]])) {
        if (number > 0) {
            number --;
        }
        return number;
    }
    else {
        if (number > 0) {
            number --;
        }
        return number;
    }
}

- (int) countUpWithFilter:(int) number {
    if (number != 10) {
        number++;
    }
    return number;
}



- (void) saveContext {
    
    if ([self.managedObjectContext hasChanges]) {
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }
    
}

@end
