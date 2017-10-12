//
//  StickersViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 09.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarEditProtocols.h"
#import "EditAvatarViewController.h"


extern NSString* const StickerToCropNotification;
extern NSString* const StickerToTextNotification;
extern NSString* const StickerToDoodleNotification;
extern NSString* const StickerToFilterNotification;

extern NSString* const StickerImageUserInfoKey;
extern NSString* const StickerSubviewsUserInfoKey;

@interface StickersViewController : UIViewController

@property (assign, nonatomic) SelectedController selectedController;

@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *trashView;
@property (weak, nonatomic) IBOutlet UIButton *addStickerButton;

- (IBAction)addStickerButtonAction:(UIButton *)sender;

- (UIImageView*) prepareToSave;
- (void)removeNotifications;

@end
