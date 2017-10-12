//
//  CustomTabSwitchAnimation.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 06.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomTabSwitchAnimation.h"

@implementation CustomTabSwitchAnimation 

- (CustomTabSwitchAnimation*) getFromIndex:(NSInteger)fromIndex andToIndex:(NSInteger)toIndex {
    
    self.fromIndex = fromIndex;
    self.toIndex = toIndex;
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.15;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* toView = toVC.view;
    UIView* fromView = fromVC.view;
    
    UIView* containerView = [transitionContext containerView];
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];
    
    
    __block CGRect newFrame;
    __block CGRect afterAnimationFrame;
    
    
    if (self.toIndex < self.fromIndex) {
        
        toView.frame = CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        newFrame = toView.frame;
        afterAnimationFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);;
       
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                       
                         newFrame.origin.x = newFrame.origin.x + newFrame.size.width;
                         toView.frame = newFrame;
                         
                     }
                     completion:^(BOOL finished) {
                         toView.frame = afterAnimationFrame;
                         [fromView removeFromSuperview];
                         [transitionContext completeTransition:YES];
                     }];
    } else {
        
        toView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        newFrame = toView.frame;
        afterAnimationFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             newFrame.origin.x = 0;
                             toView.frame = newFrame;
                             
                         }
                         completion:^(BOOL finished) {
                             toView.frame = afterAnimationFrame;
                             [fromView removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
    }
    
}

@end
