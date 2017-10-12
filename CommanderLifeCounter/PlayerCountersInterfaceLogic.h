//
//  PlayerCountersInterfaceLogic.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 30.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CountersData.h"

@interface PlayerCountersInterfaceLogic : CountersData


- (void) counterNameTxt:(NSString*)thirdCounterTxt fourthCounterTxt:(NSString*) fourthCounterTxt;
- (void) playerNameTxt:(NSString*)playerName;
- (void) updateThirdRowContent;
- (void) updateFourthRowContent;
- (float)rowHeight:(NSInteger)row;

@end
