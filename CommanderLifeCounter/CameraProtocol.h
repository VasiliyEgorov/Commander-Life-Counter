//
//  CameraProtocol.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 04.10.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AVFoundation;

@protocol CameraProtocol <NSObject>

- (void) receivePhoto:(UIImage*)photo;

@end

@protocol FocusProtocol <NSObject>

- (void) configuredDeviceCapture:(AVCaptureDevice*) device;

@end


