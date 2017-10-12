//
//  EditAvatarTabAnimations.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 22.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "EditAvatarTabAnimations.h"

@implementation EditAvatarTabAnimations

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView* toView = toVC.view;
    UIView* fromView = fromVC.view;
    
    UIView* containerView = [transitionContext containerView];
    
    [containerView addSubview:fromView];
    [containerView addSubview:toView];

    CGAffineTransform downscale = CGAffineTransformMakeScale(0.2, 0.2);
       toView.transform = downscale;
    
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                            toView.transform = CGAffineTransformIdentity;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [fromView removeFromSuperview];
                             [transitionContext completeTransition:YES];
                         }];
}

@end
