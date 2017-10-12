//
//  CustomChangeSectionButton.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 06.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomChangeSectionButton.h"


@implementation CustomChangeSectionButton



- (void)setHighlighted:(BOOL)highlighted {
    highlighted = NO;
}

- (void) setSelected:(BOOL)selected {
    
    if (selected) {

          [self setBackgroundImage:[UIImage imageNamed:@"heartfill.png"] forState:UIControlStateNormal];
    }
    else {
        
        [self setBackgroundImage:[UIImage imageNamed:@"heartstroke.png"] forState:UIControlStateNormal];
    }
 
}




@end
