//
//  AvatarData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 17.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol AlertViewProtocol <NSObject>

- (void) presentImagePicker:(UIImagePickerController*)picker;
- (void) presentCameraController:(UIViewController*)camera;
- (void) presentActionSheet:(UIAlertController*)actionSheet;
- (void) sendImageFromPicker:(UIImage*)image;



@end

@interface AlertViewData : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) id <AlertViewProtocol> delegate;
@property (strong, nonatomic) id presentingController;

- (void) showAlertStandart;

@end
