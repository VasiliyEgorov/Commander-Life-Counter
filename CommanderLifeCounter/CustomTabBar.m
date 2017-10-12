//
//  CustomTabBar.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 10.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar


- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height = 0;
    
    return sizeThatFits;
}



@end
