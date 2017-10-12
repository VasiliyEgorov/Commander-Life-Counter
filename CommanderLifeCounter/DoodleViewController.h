//
//  DoodleViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 09.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoodleView.h"
#import "ColorPaletteForDoodle.h"
#import "AvatarEditProtocols.h"
#import "EditAvatarViewController.h"

extern NSString* const DoodleToCropNotification;
extern NSString* const DoodleToStickerNotification;
extern NSString* const DoodleToTextNotification;
extern NSString* const DoodleToFilterNotification;

extern NSString* const DoodleImageUserInfoKey;
extern NSString* const DoodleSubviewsUserInfoKey;

@interface DoodleViewController : UIViewController <ControllerToDoodleProtocol>

@property (strong, nonatomic) id <DoodleToControllerProtocol> delegate;

@property (assign, nonatomic) SelectedController selectedController;

@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *buttonsLayerView;

- (void)removeNotifications;

@end
