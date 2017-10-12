//
//  AvatarData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 17.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "AlertViewData.h"
#import "CameraViewController.h"

@interface AlertViewData () <CameraProtocol>

@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIAlertController *actionSheet;

@end

@implementation AlertViewData 

#pragma mark - UIAlertController


- (void) showAlertStandart {
    
    self.actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [self.actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self.actionSheet dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self.actionSheet addAction:[UIAlertAction actionWithTitle:@"Library photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.delegate = self;
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self.delegate presentImagePicker:self.imagePicker];
        }
    }]];
    [self.actionSheet addAction:[UIAlertAction actionWithTitle:@"Take a photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                   
        CameraViewController *cameraController = [[CameraViewController alloc] initWithNibName:@"cameraXIB" bundle:nil];
        cameraController.delegate = self;
        cameraController.presentingController = self.presentingController;
        [self.delegate presentCameraController:cameraController];
        }
    }]];
    [self.delegate presentActionSheet:self.actionSheet];
}

- (void) receivePhoto:(UIImage *)photo {
    [self.delegate sendImageFromPicker:photo];
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self.delegate sendImageFromPicker:image];
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}


@end
