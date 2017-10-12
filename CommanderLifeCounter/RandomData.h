//
//  RandomData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RandomNumbersProtocol <NSObject>

- (void) getRandomNumber:(NSInteger) result;

@end

@interface RandomData : NSObject


@property (strong, nonatomic) id <RandomNumbersProtocol> delegate;


- (void) flipCoin;
- (void) rollADie;

@end
