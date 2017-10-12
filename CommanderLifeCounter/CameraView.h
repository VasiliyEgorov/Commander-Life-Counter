//
//  CameraView.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 04.10.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraProtocol.h"

@import AVFoundation;

@interface CameraView : UIView


@property (strong, nonatomic) AVCaptureDevice *captureDevice;

@end
