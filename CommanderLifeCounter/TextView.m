//
//  TextView.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "TextView.h"
#import "Constants.h"

@interface TextView ()

@property (assign, nonatomic, getter=isSelfEditing) BOOL selfEditing;
@property (assign, nonatomic, getter=isTrashOpen) BOOL trashOpen;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

@implementation TextView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:[UIScreen mainScreen].bounds.size.width / 7];
        self.textColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        self.tintColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        self.backgroundColor = [UIColor clearColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.contentSize = CGSizeZero;
        self.delegate = self;
        self.spellCheckingType = UITextSpellCheckingTypeNo;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.textContainerInset = UIEdgeInsetsMake(-10, 0, 0, 0);
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:self.panGesture];
        
    }
    return self;
}

#pragma mark - Touches

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGRect rect = CGRectMake(-self.superview.frame.size.width, self.superview.frame.size.height / 2, self.superview.frame.size.width * 3, self.superview.frame.size.height);
    
    UITouch *touch = [touches anyObject];
    
    CGPoint touchPointOnSelf = [touch locationInView:self];
    
    UIView *view = [self hitTest:touchPointOnSelf withEvent:event];
    
    self.superview.clipsToBounds = NO;
    
    if ([view isEqual:self]) {
        
        if (CGRectContainsRect(rect, self.frame)) {
           
            self.trashOpen = NO;
        }

        
        
         [self.trashViewDelegate showTrashView];
        
        
    }
    
}

- (void) panGestureAction:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint point = [recognizer translationInView:self];
    CGPoint fingerLocationOnTrashView = [recognizer locationInView:self.trashView];
    CGPoint newCenter = CGPointMake(self.center.x + point.x, self.center.y + point.y);
    
    if (!self.isSelfEditing) {
        
        CGRect rect = CGRectMake(-self.superview.frame.size.width, self.superview.frame.size.height / 2, self.superview.frame.size.width * 3, self.superview.frame.size.height );

        self.center = newCenter;
        
        if (CGRectContainsRect(rect, self.frame)) {
            
            if (!self.isTrashOpen) {
                
                self.trashOpen = YES;
                
                [self.trashViewDelegate animateTrashOpening];
                
            }
        }
        else {
            if (self.isTrashOpen) {
                
                self.trashOpen = NO;
                
                [self.trashViewDelegate animateTrashClosing];
            }
        }
        if (CGRectContainsPoint(self.trashView.bounds, fingerLocationOnTrashView)) {
            
            [self.trashViewDelegate changeTrashViewColorToReadyToDelete];
            [self.trashViewDelegate transformObjectToReadyToDelete:self];
        }
        
        else {
            
            
            [self.trashViewDelegate changeTrashViewColorToFirstState];
            [self.trashViewDelegate transformObjectToPreviousCondition:self];
            
            
        }
        
    }
    
    [recognizer setTranslation:CGPointZero inView:self];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (!CGRectContainsRect(self.superview.bounds, self.frame)) {
            
            if (CGRectContainsPoint(self.trashView.bounds, fingerLocationOnTrashView)) {
                
                [self.trashViewDelegate animateDelete:self];
                
                return;
            }
            else {
                
                CGFloat offsetX = self.frame.size.width / 2;
                CGFloat offsetY = self.frame.size.height / 2;
                CGFloat originX;
                CGFloat originY;
                CGFloat width = self.frame.size.width;
                CGFloat height = self.frame.size.height;
                CGFloat maxNegativePositionX = self.frame.size.width * 0.8;
                CGFloat maxNegativePositionY = self.frame.size.height * 0.8;
                
                if (self.frame.origin.y < -maxNegativePositionY) {
                    
                    originY = CGRectGetMinY(self.superview.bounds) - offsetY;
                }
                else if (self.frame.origin.y + self.frame.size.height > self.superview.frame.size.height + maxNegativePositionY) {
                    
                    originY = CGRectGetMaxY(self.superview.bounds) - offsetY;
                }
                else {
                    
                    originY = self.frame.origin.y;
                }
                
                if (self.frame.origin.x < -maxNegativePositionX) {
                    
                    originX = CGRectGetMinX(self.superview.bounds) - offsetX;
                }
                else if (self.frame.origin.x + self.frame.size.width > self.superview.frame.size.width + maxNegativePositionX) {
                    
                    originX = CGRectGetMaxX(self.superview.bounds) - offsetX;
                }
                else {
                    
                    originX = self.frame.origin.x;
                }
                
                CGRect correctedPosition = CGRectMake(originX, originY, width, height);
                
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     
                                     self.frame = correctedPosition;
                                     
                                 }completion:^(BOOL finished) {
                                     
                                     [self.trashViewDelegate hideTrashView];
                                     if (!self.isSelfEditing) {
                                         self.superview.clipsToBounds = YES;
                                     }
                                     
                                 }];
                
            }
        }
        else {
            [self.trashViewDelegate hideTrashView];
        }
        if (self.isSelfEditing) {
            
            self.superview.clipsToBounds = NO;
        } else {
            
            self.superview.clipsToBounds = YES;
        }
        
    }
}

#pragma mark - TextView delegate

- (void) textViewDidBeginEditing:(UITextView *)textView {
    
    self.selfEditing = YES;
    self.superview.clipsToBounds = NO;
}


- (void) textViewDidEndEditing:(UITextView *)textView {
    
    self.selfEditing = NO;
}

- (void) textViewDidChange:(UITextView *)textView {
   
    
    if (self.contentSize.height >= self.frame.size.height) {
        
        NSRange range = NSMakeRange([self.text length] - 1, 1);
        
        NSString *replacementText = EMPTY;
        
        NSString *temp = textView.text;
        
        NSString *result = [temp stringByReplacingCharactersInRange:range withString:replacementText];
        
        textView.text = result;
        
    }
  
}


#pragma mark - TextView protocol

- (void) receiveTextColor:(UIColor*)color {
    
    self.textColor = color;
    
}





@end
