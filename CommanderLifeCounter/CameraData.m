//
//  CameraData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 30.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CameraData.h"

@implementation CameraData

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeMotionManager];
    }
    return self;
}

- (void) initializeMotionManager {
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.2;
    self.motionManager.gyroUpdateInterval = 0.2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
                                                 
                                                 if (!error) {
                                                     [self outputAccelertionData:accelerometerData.acceleration];
                                                 }
                                                 else {
                                                     
                                                     NSLog(@"%@", [error localizedDescription]);
                                                 }
                                             }];
}


- (void)outputAccelertionData:(CMAcceleration)acceleration{
    
    UIImageOrientation orientationNew;
    
    if (acceleration.x >= 0.75) {
        orientationNew = UIImageOrientationLeft;
    }
    else if (acceleration.x <= -0.75) {
        orientationNew = UIImageOrientationRight;
    }
    else if (acceleration.y <= -0.75) {
        orientationNew = UIImageOrientationUp;
    }
    else if (acceleration.y >= 0.75) {
        orientationNew = UIImageOrientationDown;
    }
    else {
       
        return;
    }
    
    if (orientationNew == self.orientationLast)
        return;
    
    self.orientationLast = orientationNew;
    
    [self.delegate trackCurrentDeviceOrientation:self.orientationLast];
}


@end
