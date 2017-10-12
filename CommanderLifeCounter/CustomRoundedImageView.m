//
//  CustomRoundedImageView.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 17.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomRoundedImageView.h"
#import "UIColor+Category.h"

@implementation CustomRoundedImageView

- (void) layoutSubviews {
    self.layer.cornerRadius = 10.f;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [UIColor color_150withAlpha:1].CGColor;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

@end
