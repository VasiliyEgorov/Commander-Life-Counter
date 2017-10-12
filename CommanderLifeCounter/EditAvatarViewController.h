//
//  EditAvatarViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 17.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarData.h"


typedef NS_ENUM (NSUInteger, SelectedController) {
    CropTool,
    StickersTool,
    TextTool,
    FiltersTool,
    DoodleTool
};


@protocol EditAvatarProtocol <NSObject>

- (void)sendCroppedImageView:(UIImageView*)avatarImageView;

@end

@interface EditAvatarViewController : UITabBarController

- (instancetype)initWithOriginalPhoto:(UIImage*)originalPhoto;

@property (weak, nonatomic) id <EditAvatarProtocol> editedPhotoDelegate;

@property (strong, nonatomic) UIImage *originalPhoto;
@property (assign, nonatomic) SelectedController selectedController;
@property (assign, nonatomic) CGRect avatarImageViewFrame;



@end
