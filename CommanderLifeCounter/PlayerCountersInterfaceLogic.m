//
//  PlayerCountersInterfaceLogic.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 30.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "PlayerCountersInterfaceLogic.h"
#import "Constants.h"

@interface PlayerCountersInterfaceLogic ()


@property (assign, nonatomic) NSInteger firstRow;
@property (assign, nonatomic) NSInteger secondRow;
@property (assign, nonatomic) NSInteger thirdRow;
@property (assign, nonatomic) NSInteger fourthRow;
@property (assign, nonatomic) NSInteger thithRow;
@property (assign, nonatomic) NSInteger viewOffset;
@property (assign, nonatomic) CGFloat h;

@end

@implementation PlayerCountersInterfaceLogic

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.h = [UIScreen mainScreen].bounds.size.height;
    }
    return self;
}

#pragma mark - TextFields

- (void) counterNameTxt:(NSString*)thirdCounterTxt fourthCounterTxt:(NSString*) fourthCounterTxt {
    if (self.indexObject.index == 0) {
        
        self.player.thirdCounterName = thirdCounterTxt;
        self.player.fourthCounterName = fourthCounterTxt;
    } else {
        self.opponent.thirdCounterName = thirdCounterTxt;
        self.opponent.fourthCounterName = fourthCounterTxt;
    }
    [self saveContext];
}

- (void) playerNameTxt:(NSString*)playerName {
    
    if (self.indexObject.index == 0) {
        self.player.name = playerName;
    }
    else {
        self.opponent.name = playerName;
    }
    
    [self saveContext];
}

#pragma mark - AddRows

- (id) returnCareteDown {
    UIImage *image = [UIImage imageNamed:@"caret-down.png"];
    NSData *dataImage = UIImagePNGRepresentation(image);
    return dataImage;
}

- (id) returnCareteUp {
    UIImage *image = [UIImage imageNamed:@"caret-up.png"];
    NSData *dataImage = UIImagePNGRepresentation(image);
    return dataImage;
}

- (void) updateThirdRowContent {
    
    if (self.indexObject.index == 0 && !self.player.counters.interface.isHiddenThirdRow) {
        
        self.player.counters.interface.addThirdRowButtonImage = [self returnCareteUp];
        self.player.counters.interface.isHiddenThirdRow = YES;
    }
    else if (self.indexObject.index == 0 && self.player.counters.interface.isHiddenThirdRow)  {
        
        self.player.counters.interface.addThirdRowButtonImage = [self returnCareteDown];
        self.player.counters.interface.isHiddenThirdRow = NO;
        
        self.player.counters.interface.addFourthRowButtonImage = [self returnCareteDown]; // hide fourth row if user clicked third row button
        self.player.counters.interface.isHiddenFourthRow = NO;
        
    }
    else if (self.indexObject.index == 1 && !self.opponent.counter.interface.isHiddenThirdRow) {
        
        self.opponent.counter.interface.addThirdRowButtonImage = [self returnCareteUp];
        self.opponent.counter.interface.isHiddenThirdRow = YES;
        
    }
    else if (self.indexObject.index == 1 && self.opponent.counter.interface.isHiddenThirdRow)  {
        
        self.opponent.counter.interface.addThirdRowButtonImage = [self returnCareteDown];
        self.opponent.counter.interface.isHiddenThirdRow = NO;
        
        self.opponent.counter.interface.addFourthRowButtonImage = [self returnCareteDown]; // hide fourth row if user clicked third row button
        self.opponent.counter.interface.isHiddenFourthRow = NO;
    }
    [self saveContext];
}

- (void) updateFourthRowContent {
    
    if (self.indexObject.index == 0 && !self.player.counters.interface.isHiddenFourthRow) {
        
        self.player.counters.interface.addFourthRowButtonImage = [self returnCareteUp];
        self.player.counters.interface.isHiddenFourthRow = YES;
    }
    else if (self.indexObject.index == 0 && self.player.counters.interface.isHiddenFourthRow)  {
        
        self.player.counters.interface.addFourthRowButtonImage = [self returnCareteDown];
        self.player.counters.interface.isHiddenFourthRow = NO;
        }
    else if (self.indexObject.index == 1 && !self.opponent.counter.interface.isHiddenFourthRow) {
        
        self.opponent.counter.interface.addFourthRowButtonImage = [self returnCareteUp];
        self.opponent.counter.interface.isHiddenFourthRow = YES;
    }
    else if (self.indexObject.index == 1 && self.opponent.counter.interface.isHiddenFourthRow)  {
        
        self.opponent.counter.interface.addFourthRowButtonImage = [self returnCareteDown];
        self.opponent.counter.interface.isHiddenFourthRow = NO;
    }
    [self saveContext];
}

#pragma mark - RowHeight

- (float)rowHeight:(NSInteger)section {
    
    if (self.indexObject.index == 0) {
        
        
        if (section == 0) {
            
            return [self rowHeightForFirstSectionIsHiddenThirdRow:self.player.counters.interface.isHiddenThirdRow
                                                isHiddenFourthRow:self.player.counters.interface.isHiddenFourthRow];
        }
        
        else if (section == 1) {
            
            return [self rowHeightForSecondSectionIsHiddenThirdRow:self.player.counters.interface.isHiddenThirdRow
                                                 isHiddenFourthRow:self.player.counters.interface.isHiddenFourthRow];
        }
        else if (section == 2) {
            
            return [self rowHeightForThirdSectionIsHiddenThirdRow:self.player.counters.interface.isHiddenThirdRow
                                                isHiddenFourthRow:self.player.counters.interface.isHiddenFourthRow];
        }
        else if (section == 3) {
            
            return [self rowHeightForFourthSectionIsHiddenThirdRow:self.player.counters.interface.isHiddenThirdRow
                                                 isHiddenFourthRow:self.player.counters.interface.isHiddenFourthRow];
        }
        else {
            return [self rowHeightForFifthSectionIsHiddenThirdRow:self.player.counters.interface.isHiddenThirdRow
                                                isHiddenFourthRow:self.player.counters.interface.isHiddenFourthRow];
        }
    }
    else {
        if (section == 0) {
            
            return [self rowHeightForFirstSectionIsHiddenThirdRow:self.opponent.counter.interface.isHiddenThirdRow
                                                isHiddenFourthRow:self.opponent.counter.interface.isHiddenFourthRow];
        }
        
        else if (section == 1) {
            
            return [self rowHeightForSecondSectionIsHiddenThirdRow:self.opponent.counter.interface.isHiddenThirdRow
                                                 isHiddenFourthRow:self.opponent.counter.interface.isHiddenFourthRow];
        }
        else if (section == 2) {
            
            return [self rowHeightForThirdSectionIsHiddenThirdRow:self.opponent.counter.interface.isHiddenThirdRow
                                                isHiddenFourthRow:self.opponent.counter.interface.isHiddenFourthRow];
        }
        else if (section == 3) {
            
            return [self rowHeightForFourthSectionIsHiddenThirdRow:self.opponent.counter.interface.isHiddenThirdRow
                                                 isHiddenFourthRow:self.opponent.counter.interface.isHiddenFourthRow];
        }
        else {
            return [self rowHeightForFifthSectionIsHiddenThirdRow:self.opponent.counter.interface.isHiddenThirdRow
                                                isHiddenFourthRow:self.opponent.counter.interface.isHiddenFourthRow];
        }
    }
    
}

- (float)rowHeightForFirstSectionIsHiddenThirdRow:(BOOL)isHiddenThirdRow isHiddenFourthRow:(BOOL)isHiddenFourthRow {
    
    
    
    
    if (self.h == IPHONE_6_7_PLUS){
        
        self.firstRow = 224.f;
        
        if (!isHiddenThirdRow && !isHiddenFourthRow) {
            
            return self.firstRow;
        }
        if (isHiddenThirdRow && !isHiddenFourthRow){
            
            
            self.firstRow = self.firstRow - 46;
        }
        if (isHiddenThirdRow && isHiddenFourthRow){
            
            
            self.firstRow = self.firstRow - 70;
        }
    }
    
    
     if (self.h == IPHONE_6_7){
        
        self.firstRow = 189.f;
         
         if (!isHiddenThirdRow && !isHiddenFourthRow) {
             
             return self.firstRow;
         }
         if (isHiddenThirdRow && !isHiddenFourthRow){
             
             
             self.firstRow = self.firstRow - 35;
         }
         if (isHiddenThirdRow && isHiddenFourthRow){
             
             
             self.firstRow = self.firstRow - 62;
         }
    }
    
    
     if (self.h == IPHONE_5){
    
         self.firstRow = 164.f;
         
         if (!isHiddenThirdRow && !isHiddenFourthRow) {
             
             return self.firstRow;
         }
         if (isHiddenThirdRow && !isHiddenFourthRow){
             
             
             self.firstRow = self.firstRow - 33;
         }
         if (isHiddenThirdRow && isHiddenFourthRow){
             
             
             self.firstRow = self.firstRow - 56;
         }

         
    }
    
    

       return self.firstRow;
}

- (float)rowHeightForSecondSectionIsHiddenThirdRow:(BOOL)isHiddenThirdRow isHiddenFourthRow:(BOOL)isHiddenFourthRow {
   
    if (self.h == IPHONE_6_7_PLUS){
        
        
        
        if (!isHiddenThirdRow && !isHiddenFourthRow) {
            
            self.secondRow = 132;
        }
        if (isHiddenThirdRow && !isHiddenFourthRow){
            self.secondRow = 122;
        }
        if (isHiddenThirdRow && isHiddenFourthRow){
            self.secondRow = 102;
        }
    }
    
    
    
    
    if (self.h == IPHONE_6_7){
        
        
        if (!isHiddenThirdRow && !isHiddenFourthRow) {
            
            self.secondRow = 120;
        }
        if (isHiddenThirdRow && !isHiddenFourthRow){
            self.secondRow = 106;
        }
        if (isHiddenThirdRow && isHiddenFourthRow){
            self.secondRow = 92;
        }
    }
    
    
    
    
    if (self.h == IPHONE_5){
        
        
        
        if (!isHiddenThirdRow && !isHiddenFourthRow) {
            
            self.secondRow = 100;
        }
        if (isHiddenThirdRow && !isHiddenFourthRow){
            self.secondRow = 88;
        }
        if (isHiddenThirdRow && isHiddenFourthRow){
            self.secondRow = 76;
        }

    }
    
    
    
    return self.secondRow;
}

- (float)rowHeightForThirdSectionIsHiddenThirdRow:(BOOL)isHiddenThirdRow isHiddenFourthRow:(BOOL)isHiddenFourthRow {
    
    if (self.h == IPHONE_6_7_PLUS){
        
        
        
        if (!isHiddenThirdRow && !isHiddenFourthRow) {
            
            self.thirdRow = 132;
        }
        if (isHiddenThirdRow && !isHiddenFourthRow){
            self.thirdRow = 122;
        }
        if (isHiddenThirdRow && isHiddenFourthRow){
            self.thirdRow = 102;
        }

    }
    
    
    
    if (self.h == IPHONE_6_7){
        
        if (!isHiddenThirdRow && !isHiddenFourthRow) {
            
            self.thirdRow = 120;
        }
        if (isHiddenThirdRow && !isHiddenFourthRow){
            self.thirdRow = 106;
        }
        if (isHiddenThirdRow && isHiddenFourthRow){
            self.thirdRow = 92;
        }
    }
    
    
    
    if (self.h == IPHONE_5){
        
        
        
        if (!isHiddenThirdRow && !isHiddenFourthRow) {
            
            self.thirdRow = 100;
        }
        if (isHiddenThirdRow && !isHiddenFourthRow){
            self.thirdRow = 88;
        }
        if (isHiddenThirdRow && isHiddenFourthRow){
            self.thirdRow = 76;
        }
        
    }


    return self.thirdRow;
}


- (float)rowHeightForFourthSectionIsHiddenThirdRow:(BOOL)isHiddenThirdRow isHiddenFourthRow:(BOOL)isHiddenFourthRow {
    
    if (self.h == IPHONE_6_7_PLUS){
        
        
        if (!isHiddenThirdRow && !isHiddenFourthRow) {
            
            self.fourthRow = 0;
        }
        
        if (isHiddenThirdRow && !isHiddenFourthRow){
            self.fourthRow = 122;
        }
        if (isHiddenThirdRow && isHiddenFourthRow){
            self.fourthRow = 102;
        }
    }
    
    
    
    if (self.h == IPHONE_6_7){
        
        if (!isHiddenThirdRow && !isHiddenFourthRow) {
            
            self.fourthRow = 0;
        }
        
        if (isHiddenThirdRow && !isHiddenFourthRow){
            self.fourthRow = 106;
        }
        if (isHiddenThirdRow && isHiddenFourthRow){
            self.fourthRow = 92;
        }

    }
    
    
    
    
    if (self.h == IPHONE_5){
        

        if (!isHiddenThirdRow && !isHiddenFourthRow) {
            
            self.fourthRow = 0;
        }
        if (isHiddenThirdRow && !isHiddenFourthRow){
            self.fourthRow = 88;
        }
        if (isHiddenThirdRow && isHiddenFourthRow){
            self.fourthRow = 76;
        }
        
    }

    
    return self.fourthRow;
}

- (float)rowHeightForFifthSectionIsHiddenThirdRow:(BOOL)isHiddenThirdRow isHiddenFourthRow:(BOOL)isHiddenFourthRow {
    
    if (self.h == IPHONE_6_7_PLUS){
        
        self.thithRow = 102.f;
    }
    if (self.h == IPHONE_6_7){
        
        self.thithRow = 92.f;
    }
    if (self.h == IPHONE_5){
        
        self.thithRow = 76.f;
   
    }

    if (isHiddenThirdRow && isHiddenFourthRow){
        return self.thithRow;
    }
    else {
        self.thithRow = 0;
    }
    
      return self.thithRow;
}


@end
