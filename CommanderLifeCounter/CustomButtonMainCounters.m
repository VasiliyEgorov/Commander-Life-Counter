//
//  CustomButtonMainCounters.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 13.04.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomButtonMainCounters.h"

@implementation CustomButtonMainCounters

- (void)drawRect:(CGRect)rect {
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.masksToBounds = NO;
    
}




@end
