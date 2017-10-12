//
//  CustomLabelForCounters.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 07.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomLabelForCounters.h"
#import "UIColor+Category.h"

@interface CustomLabelForCounters ()

@property (strong, nonatomic) CAShapeLayer *maskLayer;

@end

@implementation CustomLabelForCounters

- (void) layoutSubviews {
    [super layoutSubviews];
    
    [self.maskLayer removeFromSuperlayer];
    
    CGFloat fromY = 0;
    CGFloat width = self.layer.superlayer.frame.size.width / 4;
    CGFloat fromX = (self.layer.superlayer.frame.size.width / 4) - (width / 4);
    CGFloat height = self.layer.superlayer.frame.size.height + 1;
    
    CGRect rectNew = CGRectMake(fromX, fromY, width, height);
    
    
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:rectNew byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)].CGPath;
    self.maskLayer.fillColor = [UIColor color_20].CGColor;
    self.maskLayer.strokeColor = [UIColor color_20].CGColor;
    self.maskLayer.frame = rectNew;
    
    [self.layer.superlayer insertSublayer:self.maskLayer atIndex:0];
    
    self.layer.masksToBounds = YES;

    self.textColor = [UIColor color_150withAlpha:1];
   
    self.adjustsFontSizeToFitWidth = YES;
    
    self.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:(self.frame.size.height * 2.5/3)];
   
}


@end
