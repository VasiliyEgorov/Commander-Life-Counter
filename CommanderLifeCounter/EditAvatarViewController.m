//
//  EditAvatarViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 17.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "EditAvatarViewController.h"
#import "CropViewController.h"
#import "StickersViewController.h"
#import "DoodleViewController.h"
#import "TextToolViewController.h"
#import "FiltersViewController.h"
#import "UIColor+Category.h"
#import "EditAvatarTabAnimations.h"
#import "CustomNavController.h"


@interface EditAvatarViewController () <UITabBarDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) CropViewController *cropController;
@property (strong, nonatomic) StickersViewController *stickersController;
@property (strong, nonatomic) DoodleViewController *doodleController;
@property (strong, nonatomic) TextToolViewController *textToolController;
@property (strong, nonatomic) FiltersViewController *filtersController;

@end

@implementation EditAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.cropController = nil;
    self.stickersController = nil;
}

- (instancetype)initWithOriginalPhoto:(UIImage*)originalPhoto
{
    self = [super init];
    if (self) {
        
        self.delegate = self;
        
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        
        self.tabBar.translucent = YES;
        self.tabBar.tintColor = [UIColor color_150withAlpha:1];
        self.tabBar.barTintColor = [UIColor clearColor];
        self.tabBar.backgroundColor = [UIColor clearColor];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1, 1), NO, 0.0);
        UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.tabBar.backgroundImage = blank;
        
        _originalPhoto = originalPhoto;

        self.cropController = [[CropViewController alloc] initWithNibName:@"CropViewControllerXIB" bundle:nil];
        self.cropController.originalPhoto = _originalPhoto;
        CustomNavController *cropNav = [[CustomNavController alloc] initWithRootViewController:self.cropController];
        self.stickersController = [[StickersViewController alloc] initWithNibName:@"StickersViewControllerXIB" bundle:nil];
        CustomNavController *stickerNav = [[CustomNavController alloc] initWithRootViewController:self.stickersController];
        self.doodleController = [[DoodleViewController alloc] initWithNibName:@"DoodleViewControllerXIB" bundle:nil];
        CustomNavController *doodleNav = [[CustomNavController alloc] initWithRootViewController:self.doodleController];
        self.textToolController = [[TextToolViewController alloc] initWithNibName:@"TextToolViewControllerXIB" bundle:nil];
        CustomNavController *textNav = [[CustomNavController alloc] initWithRootViewController:self.textToolController];
        self.filtersController = [[FiltersViewController alloc] initWithNibName:@"FiltersViewControllerXIB" bundle:nil];
        CustomNavController *filterNav = [[CustomNavController alloc] initWithRootViewController:self.filtersController];
        
        NSMutableArray *tabViewControllers = [NSMutableArray array];
        
        [tabViewControllers addObject:cropNav];
        [tabViewControllers addObject:stickerNav];
        [tabViewControllers addObject:doodleNav];
        [tabViewControllers addObject:textNav];
        [tabViewControllers addObject:filterNav];
        
        [self setViewControllers:tabViewControllers];
        
        [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor color_150withAlpha:1]} forState:UIControlStateNormal];
        [UITabBarItem.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor color_forCropView]} forState:UIControlStateSelected];
        
        self.cropController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Crop" image:[UIImage imageNamed:@"crop.png"] tag:0];
        
        self.stickersController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Stickers" image:[UIImage imageNamed:@"sticker.png"] tag:1];
        
        self.doodleController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Doodle" image:[UIImage imageNamed:@"doodle.png"] tag:4];
        
        self.textToolController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Text" image:[UIImage imageNamed:@"text.png"] tag:2];
        
        self.filtersController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Filters" image:[UIImage imageNamed:@"filter.png"] tag:3];
        
        for (UINavigationController *navController in self.viewControllers) {
            
            UIViewController *firstController = navController.topViewController;
            [self makeBarButtonItems:firstController];
            [firstController.view setNeedsLayout];
            
        }
        
    }
    return self;
}

- (void)makeBarButtonItems:(UIViewController*)controller {
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction:)];
                                     
    controller.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonAction:)];
    controller.navigationItem.rightBarButtonItem = saveButton;
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {

    switch (item.tag) {
        case 0:
            self.cropController.selectedController = CropTool;
            self.stickersController.selectedController = CropTool;
            self.doodleController.selectedController = CropTool;
            self.textToolController.selectedController = CropTool;
            self.filtersController.selectedController = CropTool;
            self.selectedController = CropTool;
             self.tabBarController.selectedIndex = 0;
            break;
        case 1:
            self.cropController.selectedController = StickersTool;
            self.stickersController.selectedController = StickersTool;
            self.doodleController.selectedController = StickersTool;
            self.textToolController.selectedController = StickersTool;
            self.filtersController.selectedController = StickersTool;
            self.selectedController = StickersTool;
            self.tabBarController.selectedIndex = 1;
            break;
        case 2:
            self.cropController.selectedController = TextTool;
            self.stickersController.selectedController = TextTool;
            self.doodleController.selectedController = TextTool;
            self.textToolController.selectedController = TextTool;
            self.filtersController.selectedController = TextTool;
            self.selectedController = TextTool;
            self.tabBarController.selectedIndex = 2;
            break;
        case 3:
            self.cropController.selectedController = FiltersTool;
            self.stickersController.selectedController = FiltersTool;
            self.doodleController.selectedController = FiltersTool;
            self.textToolController.selectedController = FiltersTool;
            self.filtersController.selectedController = FiltersTool;
            self.selectedController = FiltersTool;
            self.tabBarController.selectedIndex = 3;
            break;
        case 4:
            self.cropController.selectedController = DoodleTool;
            self.stickersController.selectedController = DoodleTool;
            self.doodleController.selectedController = DoodleTool;
            self.textToolController.selectedController = DoodleTool;
            self.filtersController.selectedController = DoodleTool;
            self.selectedController = DoodleTool;
            self.tabBarController.selectedIndex = 4;
            break;
        
    }
   
}





- (void)saveButtonAction:(UIBarButtonItem *)sender {
    
    [self removeNotifications];
    
    switch (self.selectedController) {
        case CropTool:
           
            [self.editedPhotoDelegate sendCroppedImageView:[self.cropController prepareToSave]];
            [self dismissController:self.cropController];
            break;
        case StickersTool:
            
            [self.editedPhotoDelegate sendCroppedImageView:[self.stickersController prepareToSave]];
            [self dismissController:self.stickersController];
            break;
        case TextTool:
            
            [self.editedPhotoDelegate sendCroppedImageView:self.textToolController.avatarImageView];
            [self dismissController:self.textToolController];
            break;
        case FiltersTool:
            
            [self.editedPhotoDelegate sendCroppedImageView:self.filtersController.avatarImageView];
            [self dismissController:self.filtersController];
            break;
        case DoodleTool:
            
            [self.editedPhotoDelegate sendCroppedImageView:self.doodleController.avatarImageView];
            [self dismissController:self.doodleController];
            break;
            
    }

}

- (void) removeNotifications {
     [self.cropController removeNotifications];
    [self.stickersController removeNotifications];
    [self.textToolController removeNotifications];
    [self.filtersController removeNotifications];
    [self.doodleController removeNotifications];
}

- (void)cancelButtonAction:(UIBarButtonItem *)sender {
    
    [self removeNotifications];
    
    switch (self.selectedController) {
        case CropTool:
            [self dismissController:self.cropController];
            break;
        case StickersTool:
           [self dismissController:self.stickersController];
            break;
        case TextTool:
            [self dismissController:self.textToolController];
            break;
        case FiltersTool:
            [self dismissController:self.filtersController];
            break;
        case DoodleTool:
            [self dismissController:self.doodleController];
            break;
            
    }
}

- (void) dismissController:(UIViewController*)controller {
    
    CGAffineTransform newTransform;
    UIImageView *avatarImageView;
    if ([controller isKindOfClass:[CropViewController class]]) {
        avatarImageView = self.cropController.avatarImageView;
        if (self.cropController.avatarImageView.image.size.width > self.cropController.avatarImageView.image.size.height) {
            
            newTransform = CGAffineTransformMakeScale (1, 0.7);
        }
        else {
            newTransform = CGAffineTransformMakeScale (0.7, 1);
        }
        
    }
   else if ([controller isKindOfClass:[StickersViewController class]]){
        
        avatarImageView = self.stickersController.avatarImageView;
        newTransform = CGAffineTransformMakeScale (0.7, 1);
    }
   else if ([controller isKindOfClass:[DoodleViewController class]]) {
        
        avatarImageView = self.doodleController.avatarImageView;
        newTransform = CGAffineTransformMakeScale (0.7, 1);
    }
   else if ([controller isKindOfClass:[TextToolViewController class]]) {
        
        avatarImageView = self.textToolController.avatarImageView;
        newTransform = CGAffineTransformMakeScale (0.7, 1);
    }
   else {
       avatarImageView = self.filtersController.avatarImageView;
       newTransform = CGAffineTransformMakeScale (0.7, 1);
   }
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         avatarImageView.transform = newTransform;
                         
                     } completion:^(BOOL finished) {
                         [[NSNotificationCenter defaultCenter] removeObserver:controller];
                        
                         [controller dismissViewControllerAnimated:NO completion:nil];
 
                     }];
}


- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC {
    
    
    
    
        return [[EditAvatarTabAnimations alloc] init];
    
    
}

@end
