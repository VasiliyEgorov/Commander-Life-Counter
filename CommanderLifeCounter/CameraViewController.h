//
//  CameraViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 27.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraData.h"
#import "CameraView.h"
#import "CameraProtocol.h"

@import AVFoundation;

@interface CameraViewController : UIViewController 

@property (strong, nonatomic) id presentingController;
@property (weak, nonatomic) id <CameraProtocol> delegate;
@property (strong, nonatomic) CameraData *cameraData;
@property (strong, nonatomic) IBOutlet UIView *cameraView;

@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *closeCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *flashlightButton;
@property (weak, nonatomic) IBOutlet UIButton *changeCameraButton;





- (IBAction)closeCameraButtonAction:(UIButton *)sender;
- (IBAction)flashlightButtonAction:(UIButton *)sender;
- (IBAction)changeCameraButtonAction:(UIButton *)sender;
- (IBAction)takePhotoButtonAction:(UIButton *)sender;



@end
