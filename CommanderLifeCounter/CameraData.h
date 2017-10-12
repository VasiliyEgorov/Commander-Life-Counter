//
//  CameraData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 30.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreMotion;
@import ImageIO;

@protocol CameraDataProtocol <NSObject>

- (void) trackCurrentDeviceOrientation:(NSUInteger) orientation;

@end

@interface CameraData : NSObject

@property (strong, nonatomic) id <CameraDataProtocol> delegate;

@property (assign, nonatomic) UIImageOrientation orientationLast;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end
