//
//  PlayerCounterWithContainerController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 05.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "PlayerCounterWithContainerController.h"
#import "SWRevealViewController.h"
#import "PlayerCounterViewController.h"
#import "Constants.h"
#import "CustomNavController.h"
#import "AlertViewData.h"
#import "UIColor+Category.h"
#import "AvatarViewController.h"

static NSString *kSettingsStartAnimation = @"animation";


@interface PlayerCounterWithContainerController () <AlertViewProtocol, UIGestureRecognizerDelegate>

@property (strong, nonatomic) PlayerCounterViewController *playerController;
@property (strong, nonatomic) AlertViewController *alertController;
@property (assign, nonatomic, getter=isLightButtonSelected) BOOL lightButtonSelected;
@property (strong, nonatomic) AlertViewData *alertView;
@property (strong, nonatomic) UIImage *originalPhoto;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (assign, nonatomic, getter=isAnimationShowed) BOOL animationShowed;
@property (strong, nonatomic) UIView *clickPointView;
@property (strong, nonatomic) UIImageView *armImageView;
@property (assign, nonatomic) CGRect newArmFrame;

@end

@implementation PlayerCounterWithContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewControllerSettings];
    [self fetchRequest];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self animateAnimationViews:self.clickPointView armImageView:self.armImageView];
}

- (void) viewControllerSettings {
    
    [self loadSettings];
    
    PlayerCounterViewController *vc = self.childViewControllers[0];
    self.delegate = vc;
    self.playerController = vc;
    self.dataForManaCounters = vc.data;
    
    
    [self initRightSwipes];
    [self initLeftSwipes];
    [self changeConstraints];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SlideMenuViewController *menu = [storyboard instantiateViewControllerWithIdentifier:@"Slide"];
    [self.revealViewController setRearViewController:menu];
    
    menu.delegate = self;

    [self makeMenuButton:self.menuButton addTargetToController:menu];
        
    self.alertController = [[AlertViewController alloc] init];
    [self.alertController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.alertController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self makeAvatarImageViewandLayerView];
    
    [self makeAnimationViews];
    
    self.alertView = [[AlertViewData alloc] init];
    self.alertView.delegate = self;
    self.alertView.presentingController = self;
    self.avatarImageViewFrame = self.avatarImageView.frame;
    
    self.avatarData = [[AvatarData alloc] init];
}

- (void) changeConstraints {
    
    float h = [UIScreen mainScreen].bounds.size.height;
    
    if (h == IPHONE_5) {
 
        self.containerViewBottonConstraint.constant = 71;
        
    }
    
    [self.view updateConstraintsIfNeeded];
    
}

- (void) makeMenuButton:(UIButton*)menuButton addTargetToController:(UIViewController*)menuController {
    
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
    [menuButton addTarget:menuController action:@selector((revealToggle:)) forControlEvents:UIControlEventTouchUpInside];
    
    float h = [UIScreen mainScreen].bounds.size.height;
    
    float height = 0;
    float width = 0;
    if (h == IPHONE_5) {
        height = 25;
        width = height + (height * 0.4);
    }
    if (h == IPHONE_6_7) {
        height = 25;
        width = height + (height * 0.4);
    }
    if (h == IPHONE_6_7_PLUS) {
        height = 25;
        width = height + (height * 0.5);
    }
    
    
    float originY = (self.navigationController.navigationBar.frame.size.height - height) / 2 + [UIApplication sharedApplication].statusBarFrame.size.height;
    float originX = width / 2;
   
    menuButton.frame = CGRectMake(originX, originY, width, height);
    
    [self.view addSubview:menuButton];
}

- (void) makeAvatarImageViewandLayerView {
    
    self.avatarLayerView = [UIView new];
    self.avatarLayerView.backgroundColor = [UIColor clearColor];
    
    float h = [UIScreen mainScreen].bounds.size.height;
    
    float height = 0;
    
    if (h == IPHONE_5) {
         height = AVATAR_HEIGHT_IPHONE_5;
    }
    if (h== IPHONE_6_7) {
         height = AVATAR_HEIGHT_IPHONE_6_7;
    }
    if (h == IPHONE_6_7_PLUS) {
         height = AVATAR_HEIGHT_IPHONE_6_7_PLUS;
    }
    
    float width = height;
    float originX = [UIScreen mainScreen].bounds.size.width - width - [UIScreen mainScreen].bounds.size.width / 20;
    float originY = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.avatarLayerView.frame = CGRectMake(originX, originY, width, height);
    self.avatarLayerView.layer.cornerRadius = self.avatarLayerView.frame.size.width / 2;
    self.avatarLayerView.layer.borderWidth = 3;
    self.avatarLayerView.layer.borderColor = [UIColor color_150withAlpha:1].CGColor;
    self.avatarLayerView.layer.masksToBounds = YES;
    [self.view addSubview:self.avatarLayerView];
    
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.frame = CGRectMake(3, 3, width - 6, height - 6);
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.userInteractionEnabled = YES;
    [self.avatarLayerView addSubview:self.avatarImageView];
    
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self.avatarImageView addGestureRecognizer:self.tapGesture];
}

#pragma mark - NSUserDefaults

- (void) saveSettings {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.animationShowed forKey:kSettingsStartAnimation];
    [defaults synchronize];
}

- (void) loadSettings {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.animationShowed = [defaults boolForKey:kSettingsStartAnimation];
}

#pragma mark - Animations

- (void) makeAnimationViews {
    
    if (self.isAnimationShowed) {
        return;
    }
    
    self.armImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointer.png"]];
    
    float offset = 5;
    float armHeigh = self.avatarImageView.frame.size.height / 8;
    float armWidth = armHeigh;
    float armOriginX = CGRectGetMidX(self.avatarImageView.bounds) - (armWidth / 2);
    float armOriginY = CGRectGetMaxY(self.avatarImageView.bounds) - armHeigh - offset;
    self.armImageView.frame = CGRectMake(armOriginX, armOriginY, armWidth, armHeigh);
    
   
    
    self.clickPointView = [UIView new];
    self.clickPointView.backgroundColor = [UIColor color_150withAlpha:1];
    float clickHeight = self.avatarImageView.frame.size.height / 15;
    float clickWidth = clickHeight;
    float clickOriginX = CGRectGetMidX(self.avatarImageView.bounds) - (clickWidth / 2);
    float clickOriginY = CGRectGetMidY(self.avatarImageView.bounds) - (clickHeight / 2);
    self.clickPointView.frame = CGRectMake(clickOriginX, clickOriginY, clickWidth, clickHeight);
    self.clickPointView.layer.cornerRadius = clickWidth / 2;
    self.clickPointView.layer.masksToBounds = YES;
    
   
    float estimatedClickWidth = clickWidth * 2;
    float estimatedClickHeight = estimatedClickWidth;
    float estimatedClickOriginY = CGRectGetMidY(self.avatarImageView.bounds) - (estimatedClickHeight / 2);
    

    float newArmOriginY = estimatedClickOriginY + estimatedClickHeight + offset;
    CGRect newArmFrame = CGRectMake(armOriginX, newArmOriginY, armWidth, armHeigh);
    self.newArmFrame = newArmFrame;
    
     [self.avatarImageView addSubview:self.armImageView];
     [self.avatarImageView addSubview:self.clickPointView];
}

- (void) animateAnimationViews:(UIView*)clickPoint armImageView:(UIImageView*)armImageView {
    
    if (self.isAnimationShowed) {
        return;
    }
   
    CGAffineTransform newTransform = CGAffineTransformMakeScale(2, 2);
    
    
    CGRect oldArmFrame = armImageView.frame;
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         
                         [UIView setAnimationRepeatCount:2.5];
                         
                         clickPoint.transform = newTransform;
                         armImageView.frame = self.newArmFrame;
                         
                     }completion:^(BOOL finished) {
                         if (finished) {
                             
                             [self animateBackAnimationViews:clickPoint armImageView:armImageView oldFrame:oldArmFrame];
                         }
                     }];
}

- (void) animateBackAnimationViews:(UIView*)clickPoint armImageView:(UIImageView*)armImageView oldFrame:(CGRect)oldFrame {
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         armImageView.frame = oldFrame;
                         clickPoint.transform = CGAffineTransformIdentity;
                         
                     } completion:^(BOOL finished) {
                         [clickPoint removeFromSuperview];
                         [armImageView removeFromSuperview];
                         self.animationShowed = YES;
                         [self saveSettings];
                     }];
}


#pragma mark - ResetCountersProtocol

- (void) resetCounters {
   
    [self.playerController.data resetAllCounters];
    [self fetchRequest];
    [self.delegate updateCounters];
}

- (void) jumpToSearch {
    self.tabBarController.selectedIndex = 3;
}


#pragma mark - Swipes

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}


- (void) initRightSwipes {
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    
}

- (void) initLeftSwipes {
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe)];
    
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    [self.view addGestureRecognizer:leftSwipe];
    
}

- (void) handleRightSwipe {
    
    if (self.revealViewController.frontViewPosition != FrontViewPositionRight) {
        
        self.tabBarController.selectedIndex = 1;
    }
    
}

- (void) handleLeftSwipe {
    
    if (self.revealViewController.frontViewPosition != FrontViewPositionRight) {
        
        self.tabBarController.selectedIndex = 2;
    }
    
}

#pragma mark - AlertViewProtocol

- (void) presentActionSheet:(UIAlertController *)actionSheet {
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) presentImagePicker:(UIImagePickerController *)picker {
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) sendImageFromPicker:(UIImage *)image {
    self.originalPhoto = image;
   
    AvatarViewController *avatar = [[AvatarViewController alloc] initWithNibName:@"AvatarViewControllerXIB" bundle:nil];
    avatar.originalPhoto = self.originalPhoto;
    avatar.avatarImageViewFrame = self.avatarImageViewFrame;
    avatar.counterIndex = self.playerController.counterIndex;
    
  
    [self.navigationController pushViewController:avatar animated:NO];
}

- (void) presentCameraController:(UIViewController *)camera {
    [self presentViewController:camera animated:YES completion:nil];
}

#pragma mark - Actions

- (void) tapGestureAction:(UIGestureRecognizer*)recognizer {
    
    [self.alertView showAlertStandart];
}


- (IBAction)turnOffAutoLockScreen:(UIBarButtonItem *)sender {
    
    if (self.isLightButtonSelected) {
        
        sender.image = [UIImage imageNamed:@"bonfire-on.png"];
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        self.lightButtonSelected = NO;
    } else {
        
        sender.image = [UIImage imageNamed:@"bonfire-off.png"];
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        self.lightButtonSelected = YES;

    }
    
    [self presentViewController:self.alertController animated:YES completion:nil];
    [self.alertController placeTextIfButtonPressed:self.lightButtonSelected];
}

- (IBAction)refreshCounters:(UIBarButtonItem *)sender {
    
    
    [self.playerController.data refreshCounters:self.playerController];
    [self.delegate updateCounters];
}

- (IBAction)jumpToNotesAction:(UIBarButtonItem *)sender {
   
    self.tabBarController.selectedIndex = 2;
    
}


- (IBAction)getToManaCounterAction:(UIButton *)sender {
   
       self.tabBarController.selectedIndex = 1;
}

- (IBAction)changeSectionFristButtonAction:(UIButton *)sender {
    [self.changeSectionSecondButton setSelected:NO];
    [self.changeSectionFristButton setSelected:YES];
    int tag = (int)sender.tag;
    [self.playerController.data getSelectedIndex:tag];
    
    [self.delegate updateCounters];

}

- (IBAction)changeSectionSecondButtonAction:(UIButton *)sender {
    [self.changeSectionFristButton setSelected:NO];
    [self.changeSectionSecondButton setSelected:YES];
    int tag = (int)sender.tag;
    [self.playerController.data getSelectedIndex:tag];
    
    [self.delegate updateCounters];

}


- (void) fetchRequest {
    
    CountersIndexManagedObject *object = [self.playerController.managedObjectContext obtainSingleManagedObjectWithEntityName:@"CountersIndexManagedObject"];
    
    if (object.index == 0) {
       
        [self.changeSectionSecondButton setSelected:NO];
        [self.changeSectionFristButton setSelected:YES];
  
    } else {
        
        [self.changeSectionFristButton setSelected:NO];
        [self.changeSectionSecondButton setSelected:YES];
        
    }
}
    





@end
