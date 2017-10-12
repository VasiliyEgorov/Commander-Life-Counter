//
//  StickerImageView.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "StickerView.h"
#import "UIColor+Category.h"


@interface StickerView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) CALayer *panAnimationLayer;
@property (strong, nonatomic) CALayer *borderLayer;
@property (assign, nonatomic, getter=isTrashOpen) BOOL trashOpen;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation StickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:self.panGesture];
        [self configurePanAnimationView];
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}



- (void) panGestureAction:(UIPanGestureRecognizer*)recognizer {
    
    CGRect rect = CGRectMake(-self.superview.frame.size.width, self.superview.frame.size.height / 2, self.superview.frame.size.width * 3, self.superview.frame.size.height);
    CGPoint point = [recognizer translationInView:self];
    CGPoint fingerLocationOnTrashView = [recognizer locationInView:self.trashView];
 
    CGPoint newCenter = CGPointMake(self.center.x + point.x, self.center.y + point.y);
    self.center = newCenter;
   
    
        if (CGRectContainsRect(rect, self.frame)) {
            
            if (!self.isTrashOpen) {
                
                self.trashOpen = YES;
                
                [self.delegate animateTrashOpening];
                
            }
        }
        else {
            if (self.isTrashOpen) {
                
                self.trashOpen = NO;
                
                [self.delegate animateTrashClosing];
            }
        }
        if (CGRectContainsPoint(self.trashView.bounds, fingerLocationOnTrashView)) {
            
            [self.delegate changeTrashViewColorToReadyToDelete];
            [self.delegate transformObjectToReadyToDelete:self];
        }
        
        else {
            
            
            [self.delegate changeTrashViewColorToFirstState];
            [self.delegate transformObjectToPreviousCondition:self];
            
            
        }
     [recognizer setTranslation:CGPointZero inView:self];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (!CGRectContainsRect(self.superview.bounds, self.frame)) {
            
            if (CGRectContainsPoint(self.trashView.bounds, fingerLocationOnTrashView)) {
                
                [self.delegate animateDelete:self];
                
                return;
            }
            else {
                
                CGFloat offset = self.frame.size.width / 2;
                CGFloat originX;
                CGFloat originY;
                CGFloat width = self.frame.size.width;
                CGFloat height = self.frame.size.height;
                CGFloat maxNegativePosition = self.frame.size.width * 0.8;
                
                if (self.frame.origin.y < -maxNegativePosition) {
                    
                    originY = CGRectGetMinY(self.superview.bounds) - offset;
                }
                else if (self.frame.origin.y + self.frame.size.height > self.superview.frame.size.height + maxNegativePosition) {
                    
                    originY = CGRectGetMaxY(self.superview.bounds) - offset;
                }
                else {
                    
                    originY = self.frame.origin.y;
                }
                
                if (self.frame.origin.x < -maxNegativePosition) {
                    
                    originX = CGRectGetMinX(self.superview.bounds) - offset;
                }
                else if (self.frame.origin.x + self.frame.size.width > self.superview.frame.size.width + maxNegativePosition) {
                    
                    originX = CGRectGetMaxX(self.superview.bounds) - offset;
                }
                else {
                    
                    originX = self.frame.origin.x;
                }
                
                CGRect correctedPosition = CGRectMake(originX, originY, width, height);
                
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     
                                     self.frame = correctedPosition;
                                     
                                     
                                 }completion:^(BOOL finished) {
                                     [self.delegate hideTrashView];
                                     self.superview.clipsToBounds = YES;
                                 }];
                
            }
        }
        else {
            [self.delegate hideTrashView];
            
        }
        self.superview.clipsToBounds = YES;
        [self animateLayerPanAnimationLayer:self.panAnimationLayer borderLayer:self.borderLayer byChangingPanOpacity:0 borderOpacity:0];
        
    }
    
}

#pragma mark - Touches

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGRect rect = CGRectMake(-self.superview.frame.size.width, self.superview.frame.size.height / 2, self.superview.frame.size.width * 3, self.superview.frame.size.height );
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPointOnSelf = [touch locationInView:self];
    
    UIView *view = [self hitTest:touchPointOnSelf withEvent:event];
    
    if ([view isEqual:self]) {
        if (CGRectContainsRect(rect, self.frame)) {
          
            self.trashOpen = NO;
         
            }

        self.superview.clipsToBounds = NO;
        
        [self.delegate showTrashView];
        
        [self animateLayerPanAnimationLayer:self.panAnimationLayer borderLayer:self.borderLayer byChangingPanOpacity:0.6 borderOpacity:1];
        
        
    }
    
}

- (void) configurePanAnimationView {
    
    self.panAnimationLayer = [CALayer new];
    self.panAnimationLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.panAnimationLayer.opacity = 0.6;
    CGFloat width = self.frame.size.width * 2;
    CGFloat height = self.frame.size.height * 2;
    CGFloat originX = - self.frame.size.width / 2;
    CGFloat originY = - self.frame.size.height / 2;
    self.panAnimationLayer.frame = CGRectMake(originX, originY, width, height);
    self.panAnimationLayer.cornerRadius = self.panAnimationLayer.frame.size.width / 2;
    self.panAnimationLayer.masksToBounds = YES;
    
    self.borderLayer = [CALayer new];
    self.borderLayer.borderWidth = 3;
    self.borderLayer.opacity = 1;
    self.borderLayer.borderColor = [UIColor whiteColor].CGColor;
    self.borderLayer.frame = self.panAnimationLayer.frame;
    self.borderLayer.cornerRadius = self.borderLayer.frame.size.width / 2;
    self.borderLayer.masksToBounds = YES;
    
    [self.layer insertSublayer:self.panAnimationLayer atIndex:0];
    [self.layer insertSublayer:self.borderLayer atIndex:1];
}



#pragma mark - Animations

- (void) animateLayerPanAnimationLayer:(CALayer*)pan borderLayer:(CALayer*)border byChangingPanOpacity:(CGFloat)panOpacity borderOpacity:(CGFloat)borderOpacity {
    
    [UIView animateWithDuration:0.25
                     animations:^{
                         border.opacity = borderOpacity;
                         pan.opacity = panOpacity;
                     }];
    
}



@end
