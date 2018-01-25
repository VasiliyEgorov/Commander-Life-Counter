//
//  DoodleViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 09.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "DoodleViewController.h"
#import "UIColor+Category.h"
#import "CropViewController.h"
#import "StickersViewController.h"
#import "TextToolViewController.h"
#import "FiltersViewController.h"
#import "TextView.h"
#import "StickerView.h"

NSString* const DoodleToCropNotification = @"DoodleToCropNotification";
NSString* const DoodleToStickerNotification = @"DoodleToStickerNotification";
NSString* const DoodleToTextNotification = @"DoodleToTextNotification";
NSString* const DoodleToFilterNotification = @"DoodleFilterNotification";

NSString* const DoodleImageUserInfoKey = @"DoodleImageUserInfoKey";
NSString* const DoodleSubviewsUserInfoKey = @"DoodleSubviewsUserInfoKey";

@interface DoodleViewController ()

@property (strong, nonatomic) DoodleView *doodleView;
@property (strong, nonatomic) ColorPaletteForDoodle *colorPalette;
@property (strong, nonatomic) UIButton *undoButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) UIImage *cropUncroppedOriginal;
@property (strong, nonatomic) UIImage *cropCroppedScaledOriginal;
@property (strong, nonatomic) UIImage *filteredUncroppedImage;

@end

@implementation DoodleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextToDoodleNotification:) name:TextToDoodleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StickerToDoodleNotification:) name:StickerToDoodleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FilterToDoodleNotification:) name:FilterToDoodleNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CropToDoodleNotification:) name:CropToDoodleNotification object:nil];
    
    

    self.avatarImageView.image = self.photo;
    self.avatarImageView.userInteractionEnabled = YES;
    self.avatarImageView.clipsToBounds = YES;
    
    self.doodleView = [[DoodleView alloc] initWithFrame:self.avatarImageView.frame];
    [self.avatarImageView addSubview:self.doodleView];
    [self addConstraintToButtonsLayerView:self.buttonsLayerView toAvatarImageView:self.avatarImageView andToLayerView:self.layerView];
    [self configureButtons];
    [self configureColorPalette];
    
    self.doodleView.delegate = self.colorPalette;
    self.doodleView.controllerToDoodleDelegate = self;
    self.delegate = self.doodleView;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.doodleView.frame = self.avatarImageView.bounds;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSMutableArray *subviewsArray = [NSMutableArray array];
    
    for (UIView *view in self.avatarImageView.subviews) {
        if ([view isKindOfClass:[DoodleView class]]) {
            view.userInteractionEnabled = NO;
        }
        [subviewsArray addObject:view];
        
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                subviewsArray, DoodleSubviewsUserInfoKey,
                                self.avatarImageView.image, DoodleImageUserInfoKey,
                                self.cropUncroppedOriginal, CropUncroppedImageUserInfoKey,
                                self.cropCroppedScaledOriginal, CropCroppedOriginalScaledUserInfoKey,
                                self.filteredUncroppedImage, FilterEditedFullSizePhotoUserInfoKey,
                                nil];
    
    
    switch (self.selectedController) {
            
        case CropTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:DoodleToCropNotification object:nil userInfo:dictionary];
            break;
        case StickersTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:DoodleToStickerNotification object:nil userInfo:dictionary];
            break;
        case FiltersTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:DoodleToFilterNotification object:nil userInfo:dictionary];
            break;
        case TextTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:DoodleToTextNotification object:nil userInfo:dictionary];
            break;
        case DoodleTool:
            
            break;
    }

    
}


#pragma mark - Notifications


- (void) TextToDoodleNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *subviewsArray = [dictionary objectForKey:TextSubviewsUserInfoKey];
    self.avatarImageView.image = [dictionary objectForKey:TextImageUserInfoKey];
    self.cropUncroppedOriginal = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.cropCroppedScaledOriginal = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    self.filteredUncroppedImage = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
    [self prepareSubviews:subviewsArray];    
}

- (void) CropToDoodleNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    self.avatarImageView.image = [dictionary objectForKey:CroppedImageUserInfoKey];
    NSArray *subviewsArray = [dictionary objectForKey:CropSubviewsArrayUserInfoKey];
    self.cropUncroppedOriginal = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.cropCroppedScaledOriginal = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    self.filteredUncroppedImage = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
   
    for (UIView *view in subviewsArray) {
        if ([view isKindOfClass:[DoodleView class]]) {
            if (view.frame.origin.y != 0 || view.frame.origin.x != 0) {
                DoodleView *doodle = [[DoodleView alloc] initWithFrame:self.avatarImageView.bounds];
                doodle.delegate = self.colorPalette;
                doodle.controllerToDoodleDelegate = self;
                self.delegate = doodle;
                [self.avatarImageView addSubview:view];
                [self.avatarImageView addSubview:doodle];
            }
            else {
                
                [self.avatarImageView addSubview:view];
            }
            view.userInteractionEnabled = YES;
        }
        if ([view isKindOfClass:[TextView class]]) {
            
            
            [self.avatarImageView addSubview:view];
            
            
        }
        if ([view isKindOfClass:[StickerView class]]) {
            
            [self.avatarImageView addSubview:view];
        }
        
        
    }

    
    
}
- (void) StickerToDoodleNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *subviewsArray = [dictionary objectForKey:StickerSubviewsUserInfoKey];
    self.avatarImageView.image = [dictionary objectForKey:StickerImageUserInfoKey];
    self.cropUncroppedOriginal = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.cropCroppedScaledOriginal = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    self.filteredUncroppedImage = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
    [self prepareSubviews:subviewsArray];
    
}

- (void) FilterToDoodleNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *subviewsArray = [dictionary objectForKey:FilterSubviewsUserInfoKey];
    self.avatarImageView.image = [dictionary objectForKey:FilterImageUserInfoKey];
    self.cropUncroppedOriginal = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.cropCroppedScaledOriginal = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    self.filteredUncroppedImage = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
    [self prepareSubviews:subviewsArray];
}

- (void) prepareSubviews:(NSArray*)subviewsArray {
    
    for (UIView *view in subviewsArray) {
        if ([view isKindOfClass:[DoodleView class]]) {
            view.userInteractionEnabled = YES;
            [self.avatarImageView addSubview:view];
        }
        if ([view isKindOfClass:[TextView class]]) {
            
            
            [self.avatarImageView addSubview:view];
            
            
        }
        if ([view isKindOfClass:[StickerView class]]) {
            
            [self.avatarImageView addSubview:view];
        }
        
        
    }

}


- (void) configureColorPalette {
    
    
    self.colorPalette = [[ColorPaletteForDoodle alloc] initWithFrame:CGRectNull];
    [self.layerView addSubview:self.colorPalette];
    [self.layerView bringSubviewToFront:self.colorPalette];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.colorPalette attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.layerView attribute:NSLayoutAttributeTop multiplier:1 constant:self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.buttonsLayerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPalette attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.colorPalette attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 45];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.colorPalette attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.layerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    [self.layerView addConstraint:top];
    [self.layerView addConstraint:bottom];
    [self.colorPalette addConstraint:width];
    [self.layerView addConstraint:trailing];
    
    self.colorPalette.translatesAutoresizingMaskIntoConstraints = NO;
    
}

#pragma mark - Constraints

- (void)addConstraintToButtonsLayerView:(UIView*)buttonsLayerView toAvatarImageView:(UIImageView*)avatarImageView andToLayerView:(UIView*)layerView {
    
    CGFloat bottomConstant = -self.tabBarController.tabBar.frame.size.height - 1;
    
    if (@available(iOS 11.0, *)) {
        bottomConstant = 0;
    }
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:buttonsLayerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:avatarImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:buttonsLayerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:layerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:buttonsLayerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:layerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:buttonsLayerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:layerView attribute:NSLayoutAttributeBottom multiplier:1 constant:bottomConstant];
    
    [layerView addConstraint:top];
    [layerView addConstraint:leading];
    [layerView addConstraint:trailing];
    [layerView addConstraint:bottom];
    
    buttonsLayerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

- (void) configureButtons {
    
    self.undoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.undoButton.frame = CGRectZero;
    [self.undoButton setTitle:@"Undo" forState:UIControlStateNormal];
    [self.undoButton addTarget:self action:@selector(undoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.undoButton setTitleColor:[UIColor color_150withAlpha:1] forState:UIControlStateNormal];
    [self.undoButton setTitleColor:[UIColor color_150withAlpha:0.4] forState:UIControlStateDisabled];
    self.undoButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:[UIScreen mainScreen].bounds.size.width / 12];
    self.undoButton.backgroundColor = [UIColor clearColor];
    
    self.resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.resetButton.frame = CGRectZero;
    [self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [self.resetButton addTarget:self action:@selector(resetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton setTitleColor:[UIColor color_150withAlpha:1] forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor color_150withAlpha:0.4] forState:UIControlStateDisabled];
    self.resetButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:[UIScreen mainScreen].bounds.size.width / 12];
    self.resetButton.backgroundColor = [UIColor clearColor];
    
    [self.buttonsLayerView addSubview:self.undoButton];
    [self.buttonsLayerView addSubview:self.resetButton];
    
    self.undoButton.enabled = NO;
    self.resetButton.enabled = NO;

    NSLayoutConstraint *undoTop = [NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *undoBottom = [NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *undoLeading = [NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *undoWidth = [NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 2];
    
    [self.buttonsLayerView addConstraint:undoTop];
    [self.buttonsLayerView addConstraint:undoBottom];
    [self.buttonsLayerView addConstraint:undoLeading];
    [self.undoButton addConstraint:undoWidth];
    
    self.undoButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *resetTop = [NSLayoutConstraint constraintWithItem:self.resetButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *resetBottom = [NSLayoutConstraint constraintWithItem:self.resetButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *resetTrailing = [NSLayoutConstraint constraintWithItem:self.resetButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *resetWidth = [NSLayoutConstraint constraintWithItem:self.resetButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 2];
    
    [self.buttonsLayerView addConstraint:resetTop];
    [self.buttonsLayerView addConstraint:resetBottom];
    [self.buttonsLayerView addConstraint:resetTrailing];
    [self.resetButton addConstraint:resetWidth];
    
    self.resetButton.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - ControllerToDoodle Protocol

- (void) disableButtons {
    
    self.undoButton.enabled = NO;
    
    int i = 0;
    
    for (DoodleView *doodle in self.avatarImageView.subviews) {
        if (doodle != nil) {
            i++;
        }
    }
    
    if (i > 1) {
        self.resetButton.enabled = YES;
    }
    else {
        
    self.resetButton.enabled = NO;
    }
}

- (void) enableButtons {

    self.undoButton.enabled = YES;
    self.resetButton.enabled = YES;
}

#pragma mark - Actions

- (IBAction)resetButtonAction:(UIButton *)sender {

    for (DoodleView *doodle in self.avatarImageView.subviews) {
        self.doodleView = doodle;
        [self.doodleView removeFromSuperview];
        self.doodleView = nil;
    }
    
    self.doodleView = [[DoodleView alloc] initWithFrame:self.avatarImageView.bounds];
    [self.avatarImageView addSubview:self.doodleView];

    self.doodleView.delegate = self.colorPalette;
    self.doodleView.controllerToDoodleDelegate = self;
    self.delegate = self.doodleView;
    
    [self.delegate resetButton];
}

- (IBAction)undoButtonAction:(UIButton *)sender {
    
    [self.delegate undoButton];
    
}

- (void)removeNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
