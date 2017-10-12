//
//  DoodleView.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 04.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "DoodleView.h"
#import "UIColor+Category.h"

@interface DoodleView () 

@property (assign, nonatomic) CGPoint touchLocation;
@property (strong, nonatomic) UIColor *colorPicker;
@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) NSMutableArray *pathsArray;
@property (strong, nonatomic) NSMutableArray *colorsArray;

@end

@implementation DoodleView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.pathsArray = [NSMutableArray array];
        self.colorsArray = [NSMutableArray array];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.pathsArray = [NSMutableArray array];
        self.colorsArray = [NSMutableArray array];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    int i = 0;
    
    for (UIBezierPath *path in self.pathsArray) {
        UIColor *color = [self.colorsArray objectAtIndex:i];
        i++;
        [color setStroke];
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
        
        [path stroke];
    }
    
}

#pragma mark - ColorPalette Protocol

- (void) receivePathColor:(UIColor *)color {
   
    self.colorPicker = color;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    
    UITouch *touch = [touches anyObject];
    CGPoint touchOnSelf = [touch locationInView:self];
    UIView *view = [self hitTest:touchOnSelf withEvent:event];
    
    if ([view isEqual:self]) {
        
        [self.delegate hideColorPalette];
        
    self.path = [[UIBezierPath alloc] init];
    self.path.lineWidth = [self.delegate receiveLineToolWidth];
    self.path.lineJoinStyle = kCGLineJoinRound;
    self.path.lineCapStyle = kCGLineJoinRound;
    UITouch *touch = [touches anyObject];
    [self.path moveToPoint:[touch locationInView:self]];
    [self.pathsArray addObject:self.path];
    [self.colorsArray addObject:[self.delegate receiveColor]];
    
    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchOnSelf = [touch locationInView:self];
    UIView *view = [self hitTest:touchOnSelf withEvent:event];
    
    if ([view isEqual:self]) {
        if (!self.path) {
            [self touchesBegan:touches withEvent:event];
        }
        [self.path addLineToPoint:[touch locationInView:self]];
        [self setNeedsDisplay];
        
    } else {
        self.path = nil;
    }
    
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint touchOnSelf = [touch locationInView:self];
    UIView *view = [self hitTest:touchOnSelf withEvent:event];
    
    if ([view isEqual:self]) {
        [self.path addLineToPoint:[touch locationInView:self]];
        [self setNeedsDisplay];

    }
    
    if ([self.pathsArray count] == 0) {
        
        [self.controllerToDoodleDelegate disableButtons];
    } else {
        
        [self.controllerToDoodleDelegate enableButtons];
    }
    
    [self.delegate showColorPalette];
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self touchesEnded:touches withEvent:event];
}




- (void) undoButton{
    
    [self.pathsArray removeLastObject];
    [self.colorsArray removeLastObject];
    [self setNeedsDisplay];
    
    if ([self.pathsArray count] == 0) {
        
        [self.controllerToDoodleDelegate disableButtons];
    } else {
        
        [self.controllerToDoodleDelegate enableButtons];
    }

}

- (void) resetButton {
    
    [self.pathsArray removeAllObjects];
    [self.colorsArray removeAllObjects];
    [self setNeedsDisplay];
    
    if ([self.pathsArray count] == 0) {
        
        [self.controllerToDoodleDelegate disableButtons];
    } else {
        
        [self.controllerToDoodleDelegate enableButtons];
    }

}

- (NSArray*)receivePathsArray {
    
    return self.pathsArray;
}


@end
