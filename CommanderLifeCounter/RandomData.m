//
//  RandomData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "RandomData.h"

@implementation RandomData


- (void) flipCoin {
    
    NSInteger result = arc4random_uniform(2);
    
    [self.delegate getRandomNumber:result];

}

- (void) rollADie {
    
    NSInteger result = arc4random_uniform(6) + 1;
    
    [self.delegate getRandomNumber:result];
    
}

@end
