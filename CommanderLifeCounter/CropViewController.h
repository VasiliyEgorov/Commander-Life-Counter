//
//  CropViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 09.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CropData.h"
#import "EditAvatarViewController.h"

extern NSString* const CropToStickerNotification;
extern NSString* const CropToDoodleNotification;
extern NSString* const CropToTextNotification;
extern NSString* const CropToFilterNotification;

extern NSString* const CroppedImageUserInfoKey;
extern NSString* const CropSubviewsArrayUserInfoKey;
extern NSString* const CropUncroppedImageUserInfoKey;
extern NSString* const CropCroppedOriginalScaledUserInfoKey;

@interface CropViewController : UIViewController <UIScrollViewDelegate, CropProtocol>

@property (assign, nonatomic) SelectedController selectedController;

@property (strong, nonatomic) UIImage *originalPhoto;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewButtomConstraint;
@property (weak, nonatomic) IBOutlet UIView *buttonLayerView;
@property (weak, nonatomic) IBOutlet UIButton *rotateButton;

- (IBAction)rotateButtonAction:(UIButton *)sender;

- (UIImageView*) prepareToSave;
- (void)removeNotifications;

@end
