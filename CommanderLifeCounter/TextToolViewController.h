//
//  TextToolViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 10.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvatarEditProtocols.h"
#import "EditAvatarViewController.h"


extern NSString* const TextToCropNotification;
extern NSString* const TextToStickerNotification;
extern NSString* const TextToDoodleNotification;
extern NSString* const TextToFilterNotification;

extern NSString* const TextImageUserInfoKey;
extern NSString* const TextSubviewsUserInfoKey;

@interface TextToolViewController : UIViewController <TrashViewProtocol>

@property (assign, nonatomic) SelectedController selectedController;

@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *trashView;
@property (weak, nonatomic) IBOutlet UIButton *addTextButton;

- (IBAction)addTextButtonAction:(UIButton *)sender;

- (void)removeNotifications;

@end
