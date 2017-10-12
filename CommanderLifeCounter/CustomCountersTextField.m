//
//  CustomCountersTextField.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 04.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomCountersTextField.h"
#import "UIColor+Category.h"


@implementation CustomCountersTextField

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor clearColor];
    self.textColor = [UIColor color_150withAlpha:1];
    self.tintColor = [UIColor color_150withAlpha:1];
    NSAttributedString *str = [[NSAttributedString alloc]
                               initWithString:@"Enter General Name"
                                                              attributes:@{ NSForegroundColorAttributeName :[UIColor color_150withAlpha:0.8],
                                                                            NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Thin" size:(self.frame.size.height * 2/3)]}];
    self.attributedPlaceholder = str;
    self.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:(self.frame.size.height * 2/3)];
    }

@end
