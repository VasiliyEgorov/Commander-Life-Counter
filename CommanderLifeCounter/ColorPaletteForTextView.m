//
//  colorPaletteForTextView.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "ColorPaletteForTextView.h"

@interface ColorPaletteForTextView ()

@property (strong, nonatomic) UIColor *colorPicker;

@end

@implementation ColorPaletteForTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.image = [UIImage imageNamed:@"colorPalette.png"];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchOnSelf = [touch locationInView:self];
    
    UIView *view = [self hitTest:touchOnSelf withEvent:event];
    
    if ([view isEqual:self]) {
        
        self.colorPicker = [self recognizeColorWithPoint:touchOnSelf];
        
        [self.delegate receiveTextColor:self.colorPicker];
        
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchOnSelf = [touch locationInView:self];
    
    UIView *view = [self hitTest:touchOnSelf withEvent:event];

    if ([view isEqual:self]) {
        
        CGRect checkRect = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - 1);
        
        if (CGRectContainsPoint(checkRect, touchOnSelf)) {
            
            self.colorPicker = [self recognizeColorWithPoint:touchOnSelf];
            
            [self.delegate receiveTextColor:self.colorPicker];
            
        }
    }
    
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchOnSelf = [touch locationInView:self];
    
    UIView *view = [self hitTest:touchOnSelf withEvent:event];
    
    if ([view isEqual:self]) {
        
        self.colorPicker = [self recognizeColorWithPoint:touchOnSelf];
        
        [self.delegate receiveTextColor:self.colorPicker];
    }
    
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self touchesEnded:touches withEvent:event];
    
}

- (UIColor*) recognizeColorWithPoint:(CGPoint)point {
    
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel,
                                                 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0
                                     green:pixel[1]/255.0 blue:pixel[2]/255.0
                                     alpha:pixel[3]/255.0];
    return color;
}


@end
