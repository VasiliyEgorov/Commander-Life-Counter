//
//  CustomLabelForManaCounters.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomLabelForManaCounters.h"
#import "UIColor+Category.h"
#import "Constants.h"

@interface CustomLabelForManaCounters ()

@property (strong, nonatomic) CAShapeLayer *maskLayer;

@end

@implementation CustomLabelForManaCounters

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
    
    self.font = [self fontForEachDevice];
    
}

- (UIFont*) fontForEachDevice {
    
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    
    UIFont *font;
    
    if (h == IPHONE_6_7_PLUS) {
        font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:45];
    }
    else if (h == IPHONE_6_7) {
        font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:37];
    }
    else {
        font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28];
    }
    
    return font;
}

@end
