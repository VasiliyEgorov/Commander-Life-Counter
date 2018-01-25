//
//  CameraViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 27.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CameraViewController.h"
#import "EditNoteViewController.h"
#import "PlayerCounterWithContainerController.h"
#import "AudioSessionData.h"
#import "Constants.h"
#import "UIImage+Category.h"

#define QUEUENAME "Serial"

typedef NS_ENUM (NSUInteger, AVCamSetupResult) {
    AVCamSetupResultSuccess,
    AVCamSetupResultCameraNotAuthorized,
    AVCamSetupResultSessionConfigurationFailed
};

typedef NS_ENUM (NSUInteger, FlashButtonType) {
    FlashButtonTypeOff,
    FlashButtonTypeOn,
    FlashButtonTypeAuto
};

@interface CameraViewController () <AVCapturePhotoCaptureDelegate, CameraDataProtocol, VolumeButtonsProtocol>

@property (strong, nonatomic) AVCapturePhotoOutput *photoOutput;
@property (strong, nonatomic) AVCaptureDeviceDiscoverySession *deviceDiscoverySession;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (assign, nonatomic) AVCamSetupResult setupResult;
@property (strong, nonatomic) AVCaptureDeviceInput *deviceInput; 
@property (assign, nonatomic, getter=isSessionRunning) BOOL sessionRunning;
@property (strong, nonatomic) AVCaptureMovieFileOutput *movieFileOutput;
@property (strong, nonatomic) AVCapturePhotoSettings *photoSettings;
@property (assign, nonatomic) FlashButtonType flashType;
@property (assign, nonatomic) NSUInteger imageOrientation;
@property (strong, nonatomic) AudioSessionData *audioData;
@property (strong, nonatomic) CameraView *touchebleCameraView;
@property (nonatomic) dispatch_queue_t kSerial;

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error NS_AVAILABLE_IOS(11);

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.kSerial = dispatch_queue_create(QUEUENAME, DISPATCH_QUEUE_SERIAL);
    
    self.audioData = [[AudioSessionData alloc] init];
    self.audioData.delegate = self;
    
    self.view.alpha = 0;
    
    self.cameraData = [[CameraData alloc] init];
    self.cameraData.delegate = self;

    self.touchebleCameraView = (CameraView*)self.cameraView;
    [self.view layoutIfNeeded];
    self.touchebleCameraView.restrictedRect = self.instrumentView.frame;
    
    [self makeSession];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
        switch (self.setupResult) {
            case AVCamSetupResultSuccess:
            {
                
                [self.session startRunning];
                self.sessionRunning = self.session.isRunning;
                break;
            }
            case AVCamSetupResultCameraNotAuthorized:
            {
             
                    
                    NSString *message = NSLocalizedString(@"CommanderApp doesn't have permission to use the camera, please change privacy settings",
                                                          @"Alert message when the user has denied access to the camera");
                    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:@"CommanderApp"
                                                                                            message:message
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",
                                                                                                   @"Alert OK button")
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:nil];
                    [alerController addAction:cancelAction];
                    
                    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings",
                                                                                                     @"Button to open system settings")
                                                                             style:UIAlertActionStyleDefault
                                                                           handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                    }];
                    
                    [alerController addAction:settingsAction];
                    [self presentViewController:alerController animated:YES completion:nil];
            
                break;
            }
            case AVCamSetupResultSessionConfigurationFailed:
            {
             
                    
                    NSString *message = NSLocalizedString(@"Unable to capture media",
                                                         @"Alert message when something goes wrong during caputre session configuration");
                    
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"CommanderApp"
                                                                                             message:message
                                                                                      preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",
                                                                                                   @"Alert OK button")
                                                                           style:UIAlertActionStyleCancel
                                                                         handler:nil];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
            
                 break;
            }
        }
  
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.view.alpha = 1;
                     }];
}



#pragma mark - System version configuration

- (NSString*) chooseBackCameraVersion {
    if (@available(iOS 10.3, *)) {
        
        return AVCaptureDeviceTypeBuiltInDualCamera;
    }
   else if (@available(iOS 11, *)) {
        
        return AVCaptureDeviceTypeBuiltInDualCamera;
    }
    else {
        return AVCaptureDeviceTypeBuiltInDuoCamera;
    }
}

#pragma mark - Session

- (void) makeSession {
    
    self.session = [[AVCaptureSession alloc] init];
    
    NSArray *deviceTypes = @[AVCaptureDeviceTypeBuiltInWideAngleCamera, [self chooseBackCameraVersion]];
    
    self.deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:deviceTypes
                                                                                         mediaType:AVMediaTypeVideo
                                                                                          position:AVCaptureDevicePositionBack];
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    self.previewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    [self.touchebleCameraView.layer insertSublayer:self.previewLayer atIndex:0];
    
    self.setupResult = AVCamSetupResultSuccess;
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
            // user previously granted accsess to the camera
            break;
            
        case AVAuthorizationStatusNotDetermined:
        {
         
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (!granted) {
                    self.setupResult = AVCamSetupResultCameraNotAuthorized;
                }
           
            }];
            break;
        }
            
        default:
        {
            self.setupResult = AVCamSetupResultCameraNotAuthorized;
            break;
        }
    }
  
        [self setupSession];
  
}

- (void) setupSession {
    
    if (self.setupResult != AVCamSetupResultSuccess) {
        return;
    }
    
    NSError *error = nil;
    
    [self.session beginConfiguration];
    
    AVCaptureDevice *camera;
    
    self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
    self.photoSettings = [AVCapturePhotoSettings photoSettings];
    
    
    if ([self.presentingController isKindOfClass:[PlayerCounterWithContainerController class]]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
        
       camera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                             mediaType:AVMediaTypeVideo
                                              position:AVCaptureDevicePositionFront];
        self.photoSettings.flashMode = AVCaptureFlashModeOff;
        self.flashType = FlashButtonTypeOff;
    }
    if ([self.presentingController isKindOfClass:[EditNoteViewController class]]) {
        
        self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
        
        camera = [AVCaptureDevice defaultDeviceWithDeviceType:[self chooseBackCameraVersion]
                                                    mediaType:AVMediaTypeVideo
                                                     position:AVCaptureDevicePositionBack];
        self.photoSettings.flashMode = AVCaptureFlashModeAuto;
        self.flashType = FlashButtonTypeAuto;
    }
    
    
    
    if (!camera) {
        
        camera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                    mediaType:AVMediaTypeVideo
                                                     position:AVCaptureDevicePositionBack];
    }
    if (!camera) {
        camera = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera
                                                    mediaType:AVMediaTypeVideo
                                                     position:AVCaptureDevicePositionFront];
    }
    
    
    [self configureFlashlight:camera];
    self.photoSettings.highResolutionPhotoEnabled = YES;
    self.touchebleCameraView.captureDevice = camera;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
    
    if (!deviceInput) {
        NSLog(@"%@", [error localizedDescription]);
        self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        [self.session commitConfiguration];
        return;
    }
    if ([self.session canAddInput:deviceInput]) {
        [self.session addInput:deviceInput];
        self.deviceInput = deviceInput;
        
      
            
            UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
            AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
            if (statusBarOrientation != UIInterfaceOrientationUnknown) {
                videoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
            }
            
            self.previewLayer.connection.videoOrientation = videoOrientation;
      
    }
    else {
        self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        [self.session commitConfiguration];
        return;
    }
    
    AVCapturePhotoOutput *photoOutput = [[AVCapturePhotoOutput alloc] init];
    if ([self.session canAddOutput:photoOutput]) {
        [self.session addOutput:photoOutput];
    
    self.photoOutput = photoOutput;
    
    self.photoOutput.highResolutionCaptureEnabled = YES;
    
   
    }
    else {
        self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        [self.session commitConfiguration];
        return;
    }
    
   
    
    [self.session commitConfiguration];
    
    
}

- (void)configureFlashlight:(AVCaptureDevice*)device {
    
    if (device.position == AVCaptureDevicePositionBack) {
        self.flashlightButton.enabled = YES;
        switch (self.flashType) {
            case FlashButtonTypeAuto:
            {
                [self.flashlightButton setBackgroundImage:[UIImage imageNamed:@"flash-auto.png"] forState:UIControlStateNormal];
                self.flashType = FlashButtonTypeAuto;
                break;
            }
                
            case FlashButtonTypeOn:
            {
                [self.flashlightButton setBackgroundImage:[UIImage imageNamed:@"flash-on.png"] forState:UIControlStateNormal];
                self.flashType = FlashButtonTypeOn;
                break;
            }
                
            case FlashButtonTypeOff:
            {
                [self.flashlightButton setBackgroundImage:[UIImage imageNamed:@"flash-off.png"] forState:UIControlStateNormal];
                self.flashType = FlashButtonTypeOff;
                break;
            }
        }
        [self configurePhotoSettings:self.flashType];
    }
    else {
        
        self.flashlightButton.enabled = NO;
        [self.flashlightButton setBackgroundImage:[UIImage imageNamed:@"flash-off.png"] forState:UIControlStateNormal];
        
        [self configurePhotoSettings:FlashButtonTypeOff];
    }
}

- (void) configurePhotoSettings:(NSUInteger)flashSettings {
    
    
    self.photoSettings.flashMode = flashSettings;
    
}



#pragma mark - Button actions

- (IBAction)closeCameraButtonAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)flashlightButtonAction:(UIButton *)sender {
    
    if (self.flashType == FlashButtonTypeAuto) {
        
        self.flashType = FlashButtonTypeOff;
        [self.flashlightButton setBackgroundImage:[UIImage imageNamed:@"flash-off.png"] forState:UIControlStateNormal];
    }
    else if (self.flashType == FlashButtonTypeOff) {
        
        self.flashType = FlashButtonTypeOn;
        [self.flashlightButton setBackgroundImage:[UIImage imageNamed:@"flash-on.png"] forState:UIControlStateNormal];
    }
    else {
        
        [self.flashlightButton setBackgroundImage:[UIImage imageNamed:@"flash-auto.png"] forState:UIControlStateNormal];
        self.flashType = FlashButtonTypeAuto;
    }
    
    [self configurePhotoSettings:self.flashType];
}



- (IBAction)changeCameraButtonAction:(UIButton *)sender {
   
        AVCaptureDevice *currentDevice = self.deviceInput.device;
        AVCaptureDevicePosition currentPosition = currentDevice.position;
        
        AVCaptureDevicePosition preferredPosition;
        AVCaptureDeviceType preferredDeviceType;
        
        switch (currentPosition) {
                
            case AVCaptureDevicePositionUnspecified:
            case AVCaptureDevicePositionFront:
                preferredPosition = AVCaptureDevicePositionBack;
                preferredDeviceType = [self chooseBackCameraVersion];
                break;
            
            case AVCaptureDevicePositionBack:
                preferredPosition = AVCaptureDevicePositionFront;
                preferredDeviceType = AVCaptureDeviceTypeBuiltInWideAngleCamera;
                break;
        }
        NSArray *devices = self.deviceDiscoverySession.devices;
    
        AVCaptureDevice *newDevice = nil;
        
        for (AVCaptureDevice *device in devices) {
            if (device.position != preferredPosition && [device.deviceType isEqualToString:preferredDeviceType]) {
               
                newDevice = [AVCaptureDevice defaultDeviceWithDeviceType:preferredDeviceType mediaType:AVMediaTypeVideo position:preferredPosition];
                [self configureFlashlight:newDevice];
                break;
            }
        }
        if (!newDevice) {
            
            for (AVCaptureDevice *device in devices) {
                if (device.position == preferredPosition) {
                    
                    newDevice = device;
                    [self configureFlashlight:newDevice];
                  
                    break;
                }
            }
        }
        if (newDevice) {
            
            AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:nil];
            
            self.touchebleCameraView.captureDevice = newDevice;
            
            [self.session beginConfiguration];
            
            [self.session removeInput:self.deviceInput];
            
            self.session.sessionPreset = [self changeSessionPresetDependingOnPosition:deviceInput.device.position];
            
            if ([self.session canAddInput:deviceInput]) {
          
                [self.session addInput:deviceInput];
                self.deviceInput = deviceInput;
            }
            else {
                
                [self.session addInput:self.deviceInput];
            }
            
            AVCaptureConnection *movieFileOutputConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if (movieFileOutputConnection.isVideoStabilizationSupported) {
                movieFileOutputConnection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            }
            
            [self.session commitConfiguration];
        }
        
  }


- (IBAction)takePhotoButtonAction:(UIButton *)sender {
   

    AVCaptureVideoOrientation videoPreviewLayerVideoOrientation = self.previewLayer.connection.videoOrientation;
    
    dispatch_async(self.kSerial, ^{
        
        AVCaptureConnection *photoOutputConnection = [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
        photoOutputConnection.videoOrientation = videoPreviewLayerVideoOrientation;
        
        AVCapturePhotoSettings *photoSettings = [AVCapturePhotoSettings photoSettingsFromPhotoSettings:self.photoSettings];
        
        if (photoSettings.availablePreviewPhotoPixelFormatTypes.count > 0) {
            
            photoSettings.previewPhotoFormat = @{(NSString*)kCVPixelBufferPixelFormatTypeKey:photoSettings.availablePreviewPhotoPixelFormatTypes.firstObject};
        }
        [self.photoOutput capturePhotoWithSettings:photoSettings delegate:self]; //// relizovat dlia bolwih versiy
    });
    
}


#pragma mark - Configure Session Preset

- (NSString*) changeSessionPresetDependingOnPosition:(NSInteger)position {
    
    
    if (position == AVCaptureDevicePositionBack) {
      
        return AVCaptureSessionPreset1920x1080;
    }
    else {
        return AVCaptureSessionPreset1280x720;
    }
}


#pragma mark - CameraData protocol

- (void) trackCurrentDeviceOrientation:(NSUInteger)orientation {
    
    self.imageOrientation = orientation;
    
    
}

#pragma mark - VolumeButtons protocol

- (void) volumeButtonPressed {
    
    [self.takePhotoButton sendAction:@selector(takePhotoButtonAction:) to:self forEvent:nil];
}

- (UIImage*) correctToPreferredOrientation:(UIImage*)image dependingOnPosition:(NSInteger)position {
    
    UIImage *rotatedImage;
    
    if (position == AVCaptureDevicePositionBack) {
    
    if (image.imageOrientation == UIImageOrientationRight) {
        rotatedImage = [[UIImage alloc] initWithCGImage:image.CGImage
                                                  scale:image.scale
                                            orientation:UIImageOrientationUp];
    }
    else if (image.imageOrientation == UIImageOrientationDown) {
        rotatedImage = [[UIImage alloc] initWithCGImage:image.CGImage
                                                  scale:image.scale
                                            orientation:UIImageOrientationLeft];
    }
    else if (image.imageOrientation == UIImageOrientationLeft) {
        rotatedImage = [[UIImage alloc] initWithCGImage:image.CGImage
                                                  scale:image.scale
                                            orientation:UIImageOrientationDown];
    }
    else {
        rotatedImage = [[UIImage alloc] initWithCGImage:image.CGImage
                                                  scale:image.scale
                                            orientation:UIImageOrientationRight];
    }
    }
    else {
        if (image.imageOrientation == UIImageOrientationRight) {
            rotatedImage = [[UIImage alloc] initWithCGImage:image.CGImage
                                                      scale:image.scale
                                                orientation:UIImageOrientationDownMirrored];
        }
        else if (image.imageOrientation == UIImageOrientationDown) {
            rotatedImage = [[UIImage alloc] initWithCGImage:image.CGImage
                                                      scale:image.scale
                                                orientation:UIImageOrientationRightMirrored];
        }
        else if (image.imageOrientation == UIImageOrientationLeft) {
            rotatedImage = [[UIImage alloc] initWithCGImage:image.CGImage
                                                      scale:image.scale
                                                orientation:UIImageOrientationUpMirrored];
        }
        else {
            rotatedImage = [[UIImage alloc] initWithCGImage:image.CGImage
                                                      scale:image.scale
                                                orientation:UIImageOrientationLeftMirrored];
        }

    }

    return rotatedImage;
}



#pragma mark - AVCapturePhotoCapture delegate iOS 10

- (void) captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error {
    
    if (@available(iOS 10, *)) {

    dispatch_async(self.kSerial, ^{
        
        if (self.isSessionRunning) {
            [self.session stopRunning];
            self.sessionRunning = self.session.isRunning;
        }
    });
    
    if (photoSampleBuffer) {
        
        NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
        
        UIImage *image = [UIImage imageWithData:data];
        
        UIImage *originalOrientationImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:self.imageOrientation];
        
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        
        UIImage *fixedOrientationImage;
        
        if (h != IPHONE_5) {
            CGFloat newScale = 1.5;
            UIImage *upScaled = [UIImage lanczosScaleFilter:originalOrientationImage scaleTo:newScale];
            fixedOrientationImage = [self correctToPreferredOrientation:upScaled dependingOnPosition:self.deviceInput.device.position];
        }
        else {
            fixedOrientationImage = [self correctToPreferredOrientation:originalOrientationImage dependingOnPosition:self.deviceInput.device.position];
        }

        [self.delegate receivePhoto:fixedOrientationImage];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    }
}

#pragma mark - AVCapturePhotoCapture delegate iOS 11

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error  {
    
    if (@available(iOS 11, *)) {

    NSData *data = [photo fileDataRepresentation];
    
    UIImage *image = [UIImage imageWithData:data];
    
    UIImage *originalOrientationImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:self.imageOrientation];
    
        CGFloat h = [UIScreen mainScreen].bounds.size.height;
        
        UIImage *fixedOrientationImage;
        
        if (h != IPHONE_5) {
            CGFloat newScale = 1.5;
            UIImage *upScaled = [UIImage lanczosScaleFilter:originalOrientationImage scaleTo:newScale];
            fixedOrientationImage = [self correctToPreferredOrientation:upScaled dependingOnPosition:self.deviceInput.device.position];
        }
        else {
            fixedOrientationImage = [self correctToPreferredOrientation:originalOrientationImage dependingOnPosition:self.deviceInput.device.position];
        }
        
    
    [self.delegate receivePhoto:fixedOrientationImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
