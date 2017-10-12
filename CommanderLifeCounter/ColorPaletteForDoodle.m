//
//  ColorPaletteImageView.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 05.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "ColorPaletteForDoodle.h"
#import "Constants.h"

#define DEFAULT_TOOL_WIDTH 3

@interface ColorPaletteForDoodle ()

@property (strong, nonatomic) UIColor *colorPicker;
@property (strong, nonatomic) UIView *viewForIndicator;
@property (strong, nonatomic) UIView *indicatorView;
@property (assign, nonatomic) CGFloat widthIncrement;
@property (assign, nonatomic) CGFloat availableSpace;
@property (assign, nonatomic) CGFloat estimatedPosition;
@property (assign, nonatomic) CGFloat currentWidthForLineTool;
@property (assign, nonatomic) CGFloat maxLineToolWidth;
@property (assign, nonatomic) CGFloat startOffset;
@property (assign, nonatomic) CGPoint firstTouchLocationOnSuperview;
@property (assign, nonatomic) CGPoint firstTouchLocationOnSelf;

@end

@implementation ColorPaletteForDoodle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"colorPalette.png"];
        self.userInteractionEnabled = YES;
        self.currentWidthForLineTool = DEFAULT_TOOL_WIDTH;
    }
    return self;
}

#pragma mark - Touches

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    self.currentWidthForLineTool = DEFAULT_TOOL_WIDTH;
    
    if (touches.count == 1) {

    UITouch *touch = [touches anyObject];
        
    self.firstTouchLocationOnSuperview = [touch locationInView:self.superview];
        
        self.firstTouchLocationOnSelf = [touch locationInView:self];
        
        if ([touch.view isEqual:self]) {
            
            self.colorPicker = [self recognizeColorWithPoint:self.firstTouchLocationOnSelf];
            [self configureIndicatorViewWithPoint:self.firstTouchLocationOnSuperview andColor:self.colorPicker];
        }

    }
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
   if (touches.count == 1) {
       
    UITouch *touch = [touches anyObject];
      CGPoint newTouchLocationOnSuperview = [touch locationInView:self.superview];
       
       CGFloat deltaX = newTouchLocationOnSuperview.x - self.firstTouchLocationOnSuperview.x;
       CGFloat deltaY = newTouchLocationOnSuperview.y - self.firstTouchLocationOnSuperview.y;
       
       CGFloat offsetBetweenOriginXAndFinger = self.viewForIndicator.frame.origin.x + self.startOffset;
       
       if (self.viewForIndicator.frame.origin.x > self.estimatedPosition || newTouchLocationOnSuperview.x > offsetBetweenOriginXAndFinger) {
           
       
       CGRect newFrame = CGRectMake(self.viewForIndicator.frame.origin.x + deltaX, self.viewForIndicator.frame.origin.y + deltaY, self.viewForIndicator.frame.size.width, self.viewForIndicator.frame.size.height);
       [UIView animateWithDuration:0.1 animations:^{
           self.viewForIndicator.frame = newFrame;
       }];
       
       [self changeWidthForLineTool:self.viewForIndicator.frame.origin.x];
       }
       
       else {
           CGRect newFrame = CGRectMake(self.estimatedPosition, self.viewForIndicator.frame.origin.y + deltaY, self.viewForIndicator.frame.size.width, self.viewForIndicator.frame.size.height);
           [UIView animateWithDuration:0.1 animations:^{
               self.viewForIndicator.frame = newFrame;
           }];
           [self changeWidthForLineTool:self.viewForIndicator.frame.origin.x];
       }
       CGPoint touchOnSelf = [touch locationInView:self];
       CGPoint newPointForColorPicker = CGPointMake(self.firstTouchLocationOnSelf.x, touchOnSelf.y);
       
       CGRect checkRect = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - 1);
       
       if (CGRectContainsPoint(checkRect, newPointForColorPicker)) {
           
           self.colorPicker = [self recognizeColorWithPoint:newPointForColorPicker];
       }
       
       [self updateViewForIndicatorAndIndicatorColor:self.colorPicker];
            self.firstTouchLocationOnSuperview = newTouchLocationOnSuperview;
       }

}
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
     UIView *view = [self hitTest:point withEvent:event];
    
    if ([view isEqual:self]) {
        self.colorPicker = [self recognizeColorWithPoint:point];
    }
    
    
    [self hideViewForIndicator:self.viewForIndicator andIndicatorView:self.indicatorView withStartOffset:self.startOffset];
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


- (void) configureIndicatorViewWithPoint:(CGPoint)point andColor:(UIColor*)color {
    
    
    CGFloat width = self.superview.bounds.size.width / 8;
    CGFloat height = width;
    CGFloat originX = point.x - self.bounds.size.width - width * 3;
    CGFloat originY = point.y - width / 2;
    
    self.startOffset = self.superview.bounds.size.width - originX;
    
    CGRect newFrameViewForIndicator = CGRectMake(originX, originY, width, height);
    
    self.viewForIndicator = [[UIView alloc] initWithFrame:CGRectMake(self.superview.bounds.size.width, originY, 1, 1)];
    self.viewForIndicator.backgroundColor = [UIColor whiteColor];
    self.viewForIndicator.layer.cornerRadius = width / 2;
    self.viewForIndicator.layer.masksToBounds = YES;
    self.viewForIndicator.layer.borderColor = color.CGColor;
    self.viewForIndicator.layer.borderWidth = width / 20;
    
    self.maxLineToolWidth = width - self.viewForIndicator.layer.borderWidth * 4;
    
    CGFloat widthForIndicator = self.currentWidthForLineTool;
    CGFloat heightForIndicator = widthForIndicator;
    CGFloat originXForIndicator = newFrameViewForIndicator.size.width / 2 - widthForIndicator / 2;
    CGFloat originYForIndicator = newFrameViewForIndicator.size.height / 2 - heightForIndicator / 2;
    
    CGRect newFrameIndicatorView = CGRectMake(originXForIndicator, originYForIndicator, widthForIndicator, heightForIndicator);
    
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(self.viewForIndicator.frame.origin.x, self.viewForIndicator.frame.origin.y, 1, 1)];
    self.indicatorView.layer.cornerRadius = widthForIndicator / 2;
    self.indicatorView.layer.masksToBounds = YES;
    self.indicatorView.backgroundColor = color;

    [self.viewForIndicator addSubview:self.indicatorView];
    [self.superview addSubview:self.viewForIndicator];
    
    [self showViewForIndicator:self.viewForIndicator withNewFrame:newFrameViewForIndicator andIndicatorView:self.indicatorView withNewFrame:newFrameIndicatorView];
    [self configureWidthIncrementForMaxLineToolWidth:self.maxLineToolWidth dependingOnOriginX:newFrameViewForIndicator.origin.x];
   }

- (void) configureWidthIncrementForMaxLineToolWidth:(CGFloat)maxLineToolWidth dependingOnOriginX:(CGFloat)originX {
    
    self.availableSpace = originX;
    self.widthIncrement = maxLineToolWidth / self.availableSpace;
    self.estimatedPosition = self.currentWidthForLineTool / self.widthIncrement;
    
}

- (void) changeWidthForLineTool:(CGFloat)originX {
 
    self.currentWidthForLineTool = (self.availableSpace - originX + self.estimatedPosition) * self.widthIncrement;

    CGRect newFrame = CGRectMake(self.indicatorView.frame.origin.x, self.indicatorView.frame.origin.y,
                                  self.currentWidthForLineTool, self.currentWidthForLineTool);
    CGPoint newCenter = CGPointMake(CGRectGetMidX(self.viewForIndicator.bounds), CGRectGetMidY(self.viewForIndicator.bounds));
    
    self.indicatorView.frame = newFrame;
    self.indicatorView.center = newCenter;
    self.indicatorView.layer.cornerRadius = self.indicatorView.frame.size.width / 2;
    
}


- (void) updateViewForIndicatorAndIndicatorColor:(UIColor*) color {
    
    self.viewForIndicator.layer.borderColor = color.CGColor;
    self.indicatorView.backgroundColor = color;
}

#pragma mark - ColorPalette delegate

- (CGFloat) receiveLineToolWidth {
    
    return self.currentWidthForLineTool;
}

- (UIColor*) receiveColor {
    
    if (!self.colorPicker) {
        
        return [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    } else{
        
        return self.colorPicker;
    }
}

- (void) hideColorPalette {
    
    if (self.frame.origin.x == self.superview.frame.size.width) {
        return;
    }
    
    CGRect newFrame = CGRectMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.frame = newFrame;
                        
                     }];
}
- (void) showColorPalette {
   
    CGRect newFrame = CGRectMake(self.frame.origin.x - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.frame = newFrame;
                     }];
}

#pragma mark - Animations

- (void) showViewForIndicator:(UIView*)viewForIndicator withNewFrame:(CGRect)newViewFrame andIndicatorView:(UIView*)indicatorView withNewFrame:(CGRect)newIndFrame  {
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         viewForIndicator.frame = newViewFrame;
                         indicatorView.frame = newIndFrame;
                     }];
}

- (void) hideViewForIndicator:(UIView*)viewForIndicator andIndicatorView:(UIView*)indicatorView withStartOffset:(CGFloat)offset {
    
    CGRect newFrameViewForInd = CGRectMake(viewForIndicator.frame.origin.x + offset, viewForIndicator.frame.origin.y, 1, 1);
    CGRect newFrameInd = CGRectMake(indicatorView.frame.origin.x + offset, indicatorView.frame.origin.y, 0.1, 0.1);
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         viewForIndicator.frame = newFrameViewForInd;
                         indicatorView.frame = newFrameInd;
                     }completion:^(BOOL finished) {
                         
                         [viewForIndicator removeFromSuperview];
                     }];
}

@end
