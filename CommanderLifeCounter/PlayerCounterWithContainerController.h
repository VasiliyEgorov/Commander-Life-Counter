//
//  PlayerCounterWithContainerController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 05.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideMenuViewController.h"
#import "CountersData.h"
#import "AlertViewController.h"
#import "AvatarData.h"


@protocol PlayerCounterProtocol <NSObject>

- (void) updateCounters;

@end


@interface PlayerCounterWithContainerController : UIViewController <ResetCountersProtocol, UITextFieldDelegate>


@property (strong, nonatomic) CountersData *dataForManaCounters;
@property (strong, nonatomic) AvatarData *avatarData;
@property (assign, nonatomic) CGRect avatarImageViewFrame;

@property (strong, nonatomic) UIView *avatarLayerView;
@property (strong, nonatomic) UIImageView *avatarImageView;
@property (strong, nonatomic) UIImageView *addAvatarImageView;
@property (strong, nonatomic) UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *turnOffButton;
@property (weak, nonatomic) IBOutlet UIButton *changeSectionFristButton;
@property (weak, nonatomic) IBOutlet UIButton *changeSectionSecondButton;
@property (weak, nonatomic) IBOutlet UIButton *getToManaCounterButton;

- (IBAction)turnOffAutoLockScreen:(UIBarButtonItem *)sender;
- (IBAction)refreshCounters:(UIBarButtonItem *)sender;
- (IBAction)jumpToNotesAction:(UIBarButtonItem *)sender;

- (IBAction)getToManaCounterAction:(UIButton *)sender;
- (IBAction)changeSectionFristButtonAction:(UIButton *)sender;
- (IBAction)changeSectionSecondButtonAction:(UIButton *)sender;

@property (strong, nonatomic) id <PlayerCounterProtocol> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottonConstraint;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *btnTopConstraintsCollection;



@end
