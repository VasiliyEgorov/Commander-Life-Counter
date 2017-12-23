//
//  CustomCardNameLabel.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 17.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomCardDetailsLabel.h"

@implementation CustomCardDetailsLabel


- (void) layoutSubviews {
    [super layoutSubviews];

    self.adjustsFontSizeToFitWidth = YES;
    self.minimumScaleFactor = 0.5;
}

@end
