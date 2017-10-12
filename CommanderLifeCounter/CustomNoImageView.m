//
//  CustomNoImageView.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 23.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomNoImageView.h"

@implementation CustomNoImageView

- (void) layoutSubviews {
    self.image = [UIImage imageNamed:@"noImageSign.png"];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 0.5;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.masksToBounds = NO;
}

@end
