//
//  CameraView.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 04.10.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CameraView.h"

@interface CameraView ()

@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIImageView *focusFrame;
@end

@implementation CameraView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFocusOnTap:)];
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void) handleFocusOnTap:(UITapGestureRecognizer*)recognizer {
    
    if (self.captureDevice.position == AVCaptureDevicePositionBack) {
        
        
    CGPoint focusPoint = [recognizer locationInView:self];
    
    CGFloat focusX = focusPoint.x/self.frame.size.width;
    CGFloat focusY = focusPoint.y/self.frame.size.height;
  
    
 
    if (recognizer.state == UIGestureRecognizerStateEnded) {
    
 
        if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus] && [self.captureDevice isFocusPointOfInterestSupported]) {
            NSError *error = nil;
            if ([self.captureDevice lockForConfiguration:&error]) {
            
                if (error) {
                    NSLog(@"%@", [error localizedDescription]);
                }

                [self makeFocusImageViewWithLocation:focusPoint];
                
                [self.captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
                [self.captureDevice setFocusPointOfInterest:CGPointMake(focusX, focusY)];
                
                
                if ([self.captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose] && [self.captureDevice isExposurePointOfInterestSupported]) {
                 
                 [self.captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
                 [self.captureDevice setExposurePointOfInterest:CGPointMake(focusX, focusY)];
                 }
                
                 [self.captureDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
                [self.captureDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                [self.captureDevice unlockForConfiguration];
              
            }
        }
    }
      }
}




- (void) makeFocusImageViewWithLocation:(CGPoint)location {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 4;
    CGFloat height = width;
    CGFloat originX = location.x - (width / 2);
    CGFloat originY = location.y - (height / 2);
    
    self.focusFrame = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
     self.focusFrame.image = [UIImage imageNamed:@"focusAnimationLayer.png"];
    [self addSubview: self.focusFrame];
    
     self.focusFrame.alpha = 0;
    
    self.userInteractionEnabled = NO;
    
        [UIView animateWithDuration:0.6
                              delay:0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse
                         animations:^{
                             
                             [UIView setAnimationRepeatCount:1.5];
                             
                              self.focusFrame.alpha = 1;
                             
                         } completion:^(BOOL finished) {
                             
                             [UIView animateWithDuration:0.6
                                                   delay:0
                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  
                                                   self.focusFrame.alpha = 0;
                                                  
                                              } completion:^(BOOL finished) {
                                                  
                                                  [self.focusFrame removeFromSuperview];
                                                  self.userInteractionEnabled = YES;
                                              }];
                         }];
   
}


@end
