//
//  StickersViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 09.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "StickersViewController.h"
#import "StickerView.h"
#import "StickerListViewController.h"
#import "UIColor+Category.h"
#import "CropViewController.h"
#import "DoodleViewController.h"
#import "TextToolViewController.h"
#import "FiltersViewController.h"
#import "DoodleView.h"
#import "TextView.h"
#import "Constants.h"

NSString* const StickerToCropNotification = @"StickerToCropNotification";
NSString* const StickerToTextNotification = @"StickerToTextNotification";
NSString* const StickerToDoodleNotification = @"StickerToDoodleNotification";
NSString* const StickerToFilterNotification = @"StickerToFilterNotification";

NSString* const StickerImageUserInfoKey = @"StickerImageUserInfoKey";
NSString* const StickerSubviewsUserInfoKey = @"StickerSubviewsUserInfoKey";

@interface StickersViewController () <StickerListProtocol, TrashViewProtocol>

@property (strong, nonatomic) StickerView *stickerView;
@property (strong, nonatomic) StickerListViewController *stickerListController;
@property (strong, nonatomic) UIImageView *trashImageViewFirstPart;
@property (strong, nonatomic) UIImageView *trashImageViewSecondPart;
@property (assign, nonatomic) CGRect newFrameToOpenTrash;
@property (assign, nonatomic) CGRect newFrameToCloseTrash;
@property (strong, nonatomic) UIImage *cropUncroppedOriginal;
@property (strong, nonatomic) UIImage *cropCroppedScaledOriginal;
@property (strong, nonatomic) UIImage *filteredUncroppedImage;

@end

@implementation StickersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextToStickerNotification:) name:TextToStickerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoodleToStickerNotification:) name:DoodleToStickerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FilterToStickerNotification:) name:FilterToStickerNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CropToStickerNotification:) name:CropToStickerNotification object:nil];
    
 
    self.avatarImageView.userInteractionEnabled = YES;
    self.avatarImageView.clipsToBounds = YES;
    [self configureTrashView];
    [self.layerView bringSubviewToFront:self.avatarImageView];
    [self addConstraintToTrashView:self.trashView toAvatarImageView:self.avatarImageView andToLayerView:self.layerView];
    [self addConstraintsToButton:self.addStickerButton andToTrashView:self.trashView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSMutableArray *subviewsArray = [NSMutableArray array];
    
    for (UIView *view in self.avatarImageView.subviews) {
        if ([view isKindOfClass:[StickerView class]]) {
            
            StickerView *sticker = (StickerView*)view;
            CALayer *pan = [sticker.layer.sublayers objectAtIndex:0];
            CALayer *border = [sticker.layer.sublayers objectAtIndex:1];
            pan.opacity = 0;
            border.opacity = 0;
        }
        [subviewsArray addObject:view];
    }
    

    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                subviewsArray, StickerSubviewsUserInfoKey,
                                self.avatarImageView.image, StickerImageUserInfoKey,
                                self.cropUncroppedOriginal, CropUncroppedImageUserInfoKey,
                                self.cropCroppedScaledOriginal, CropCroppedOriginalScaledUserInfoKey,
                                self.filteredUncroppedImage, FilterEditedFullSizePhotoUserInfoKey,
                                nil];
    
        switch (self.selectedController) {
            
        case CropTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:StickerToCropNotification object:nil userInfo:dictionary];
            break;
        case TextTool:
             [[NSNotificationCenter defaultCenter] postNotificationName:StickerToTextNotification object:nil userInfo:dictionary];
            break;
        case FiltersTool:
             [[NSNotificationCenter defaultCenter] postNotificationName:StickerToFilterNotification object:nil userInfo:dictionary];
            break;
        case DoodleTool:
             [[NSNotificationCenter defaultCenter] postNotificationName:StickerToDoodleNotification object:nil userInfo:dictionary];
            break;
        case StickersTool:
            
            break;
    }
    
    
    
   
}

#pragma mark - Constraints


- (void)addConstraintToTrashView:(UIView*)trashView toAvatarImageView:(UIImageView*)avatarImageView andToLayerView:(UIView*)layerView {
    
    CGFloat bottomConstant = -self.tabBarController.tabBar.frame.size.height - 1;

    if (@available(iOS 11.0, *)) {
        bottomConstant = 0;
    }
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:trashView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:avatarImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:1];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:trashView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:layerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:trashView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:layerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:trashView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:layerView attribute:NSLayoutAttributeBottom multiplier:1 constant:bottomConstant];
    
    [layerView addConstraint:top];
    [layerView addConstraint:leading];
    [layerView addConstraint:trailing];
    [layerView addConstraint:bottom];
    
    trashView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

- (void) addConstraintsToButton:(UIButton*)addButton andToTrashView:(UIView*)trashView {
    
     NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:trashView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:trashView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *equalHeight = [NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:trashView attribute:NSLayoutAttributeHeight multiplier:0.35 constant:0];
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:addButton attribute:NSLayoutAttributeWidth multiplier:1/1 constant:0];
    [trashView addConstraint:centerX];
    [trashView addConstraint:centerY];
    [trashView addConstraint:equalHeight];
    [addButton addConstraint:aspectRatio];
    
    addButton.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - Notifications


- (void) TextToStickerNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *subviewsArray = [dictionary objectForKey:TextSubviewsUserInfoKey];
    self.avatarImageView.image = [dictionary objectForKey:TextImageUserInfoKey];
    self.cropUncroppedOriginal = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.cropCroppedScaledOriginal = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    self.filteredUncroppedImage = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
    [self prepareSubviews:subviewsArray];
    
}

- (void) CropToStickerNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    self.avatarImageView.image = [dictionary objectForKey:CroppedImageUserInfoKey];
    NSArray *subviewsArray = [dictionary objectForKey:CropSubviewsArrayUserInfoKey];
    self.cropUncroppedOriginal = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.cropCroppedScaledOriginal = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    self.filteredUncroppedImage = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
   [self prepareSubviews:subviewsArray];
    
}
- (void) DoodleToStickerNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *subviewsArray = [dictionary objectForKey:DoodleSubviewsUserInfoKey];
    self.avatarImageView.image = [dictionary objectForKey:DoodleImageUserInfoKey];
    self.cropUncroppedOriginal = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.cropCroppedScaledOriginal = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    self.filteredUncroppedImage = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
   [self prepareSubviews:subviewsArray];
    
}
- (void) FilterToStickerNotification:(NSNotification*)notification {
    
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
            
            [self.avatarImageView addSubview:view];
        }
        if ([view isKindOfClass:[TextView class]]) {
            
            TextView *textView = (TextView*)view;
            textView.trashViewDelegate = self;
            [self.avatarImageView addSubview:textView];
            
            
        }
        if ([view isKindOfClass:[StickerView class]]) {
            StickerView *sticker = (StickerView*)view;
            sticker.delegate = self;
            [self.avatarImageView addSubview:view];
        }
        
    }

}

- (void) configureTrashView {
    
    self.trashView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.trashView.layer.borderWidth = 0;
    self.trashImageViewFirstPart = [[UIImageView alloc] init];
    self.trashImageViewFirstPart.image = [UIImage imageNamed:@"trashForStickers_firstPart.png"];
    self.trashImageViewSecondPart = [[UIImageView alloc] init];
    self.trashImageViewSecondPart.image = [UIImage imageNamed:@"trashForStickers_secondPart.png"];
    
    [self.trashView addSubview:self.trashImageViewFirstPart];
    [self.trashView addSubview:self.trashImageViewSecondPart];
    
    self.trashImageViewFirstPart.hidden = YES;
    self.trashImageViewSecondPart.hidden = YES;
    
    
}

- (void) configureFirstPartOfTrashImageView:(UIImageView*)trashImageViewFirstPart andSecondPartOfTrashView:(UIImageView*)trashImageViewSecondPart withTrashView:(UIView*)trashView andWithOffset:(CGFloat)offsetBetweenParts {
    
    
    CGFloat widthForFirst = trashView.bounds.size.height / 4;
    CGFloat heightForFirst = widthForFirst;
    CGFloat widthForSecond = heightForFirst;
    CGFloat heightForSecond = heightForFirst / 5;
    CGFloat originXForFirst = CGRectGetMidX(trashView.bounds) - widthForFirst / 2;
    CGFloat originYForFirst = CGRectGetMidY(trashView.bounds) - heightForFirst / 2 + heightForSecond / 2 + offsetBetweenParts;
    CGFloat originXForSecond = originXForFirst;
    CGFloat originYForSecond = originYForFirst - heightForSecond - offsetBetweenParts;
    
    trashImageViewFirstPart.frame = CGRectMake(originXForFirst, originYForFirst, widthForFirst, heightForFirst);
    trashImageViewSecondPart.frame = CGRectMake(originXForSecond, originYForSecond, widthForSecond, heightForSecond);
    
    
    
    [self configureNewFrameToOpenTrash:trashImageViewSecondPart withOffset:offsetBetweenParts];
    
}

- (void) configureNewFrameToOpenTrash:(UIImageView*)trashImageViewSecondPart withOffset:(CGFloat)offsetBetweenParts {
    
    CGFloat correctionOriginX = 2;
    
    self.newFrameToOpenTrash = CGRectMake(trashImageViewSecondPart.frame.origin.x - correctionOriginX,
                                          trashImageViewSecondPart.frame.origin.y - offsetBetweenParts,
                                          trashImageViewSecondPart.frame.size.width,
                                          trashImageViewSecondPart.frame.size.height);
    
    self.newFrameToCloseTrash = trashImageViewSecondPart.frame;
    
    
}

- (void) showCollectionView {
    
    self.stickerListController = [[StickerListViewController alloc] initWithNibName:@"StickerListXIB" bundle:nil];
    self.stickerListController.delegate = self;
    
    CGFloat halfSelfViewHeight = [UIScreen mainScreen].bounds.size.height / 2;
    CGFloat originY = [UIScreen mainScreen].bounds.size.height - halfSelfViewHeight;
    CGRect frameBeforeAnimation = CGRectMake(0, originY * 2, [UIScreen mainScreen].bounds.size.width, halfSelfViewHeight);
    CGRect frameAfterAnimation = CGRectMake(0, originY, [UIScreen mainScreen].bounds.size.width, halfSelfViewHeight);
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self displayContentController:self.stickerListController withFrameBeforeAnimation:frameBeforeAnimation andWithFrameAfterAnimation:frameAfterAnimation];
}

- (void) displayContentController:(UIViewController*)controller withFrameBeforeAnimation:(CGRect)frameBeforeAnimation andWithFrameAfterAnimation:(CGRect)frameAfterAnimation {
    
    [self addChildViewController:controller];
    
    controller.view.frame = frameBeforeAnimation;
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
    
    
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             controller.view.frame = frameAfterAnimation;
                         } completion:nil];
    
    
}

#pragma mark - StickerList protocol

- (void) sendStricker:(UIImage*)sticker withSize:(CGSize)stickerSize {
    
    StickerView *stickerView = [[StickerView alloc] initWithFrame:
                        CGRectMake(0, 0, stickerSize.width, stickerSize.height)];
    [self.avatarImageView addSubview:stickerView];
    UIImageView *stickerImageView = [[UIImageView alloc] initWithFrame:stickerView.frame];
    stickerImageView.image = sticker;
    [stickerView addSubview:stickerImageView];
    
    stickerView.center = CGPointMake(CGRectGetMidX(self.avatarImageView.bounds),
                                          CGRectGetMidY(self.avatarImageView.bounds));
    
    stickerView.delegate = self;
    stickerView.trashView = self.trashView;
    
    
    
}


#pragma mark - TrashView protocol

- (void) hideTrashView {
    self.trashView.layer.borderWidth = 0;
    self.trashImageViewFirstPart.hidden = YES;
    self.trashImageViewSecondPart.hidden = YES;
    self.trashView.backgroundColor = [UIColor clearColor];
    self.addStickerButton.hidden = NO;
    [self.trashImageViewSecondPart.layer removeAllAnimations];
    self.trashImageViewSecondPart.transform = CGAffineTransformIdentity;
    self.trashImageViewSecondPart.frame = self.newFrameToCloseTrash;
}

- (void) showTrashView {
    
    [self configureFirstPartOfTrashImageView:self.trashImageViewFirstPart andSecondPartOfTrashView: self.trashImageViewSecondPart withTrashView:self.trashView andWithOffset:3];
    self.addStickerButton.hidden = YES;
    self.trashView.backgroundColor = [UIColor color_forCropView];
    self.trashView.layer.borderWidth = 1;
    self.trashImageViewFirstPart.hidden = NO;
    self.trashImageViewSecondPart.hidden = NO;
    
}

- (void) changeTrashViewColorToReadyToDelete {
    
    self.trashView.backgroundColor = [UIColor redColor];
    
}

- (void) changeTrashViewColorToFirstState {
    
    self.trashView.backgroundColor = [UIColor color_forCropView];
    
}


- (void) animateTrashOpening {
    

    CGFloat degrees = -30;
    
    self.trashImageViewSecondPart.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         self.trashImageViewSecondPart.frame =  self.newFrameToOpenTrash;
                         self.trashImageViewSecondPart.transform = CGAffineTransformMakeRotation(degrees * M_PI / 180);
                     }];
    
}


- (void) animateTrashClosing {
    

    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         self.trashImageViewSecondPart.transform = CGAffineTransformIdentity;
                         self.trashImageViewSecondPart.frame = self.newFrameToCloseTrash;
                     }];
}

- (void) animateDelete:(UIView*)objectToDelete {
    
    CGAffineTransform newTransform = CGAffineTransformMakeScale (0.1, 0.1);
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         objectToDelete.center = CGPointMake(CGRectGetMidX(self.layerView.bounds),
                                                             CGRectGetMaxY(self.avatarImageView.bounds) + CGRectGetMidY(self.trashView.bounds));
                         objectToDelete.transform = newTransform;
                         [self animateTrashClosing];
                     }completion:^(BOOL finished) {
                         
                         [objectToDelete removeFromSuperview];
                         [self hideTrashView];
                         objectToDelete.superview.clipsToBounds = YES;
                     }];
    
}

- (void) transformObjectToReadyToDelete:(UIView*)view {
    
    CALayer *panAnimationLayer = [view.layer.sublayers objectAtIndex:0];
    
    float percentDeltaHeight = 100 * ((panAnimationLayer.frame.size.height - self.trashView.frame.size.height ) / panAnimationLayer.frame.size.height);
    
    
    CGAffineTransform newTransform = CGAffineTransformMakeScale(1 - (percentDeltaHeight / 100), 1 - (percentDeltaHeight / 100));
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                       
                         view.transform = newTransform;
                         
                     }];
}
- (void) transformObjectToPreviousCondition:(UIView*)view {
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                      
                         view.transform = CGAffineTransformIdentity;
                     }];
}

#pragma mark - Actions

- (IBAction)addStickerButtonAction:(UIButton *)sender {
    
    [self showCollectionView];
}



#pragma mark - Save

- (UIImageView*) prepareToSave {
    
    for (UIView *view in self.avatarImageView.subviews) {
        if ([view isKindOfClass:[StickerView class]]) {
            
            StickerView *sticker = (StickerView*)view;
            CALayer *pan = [sticker.layer.sublayers objectAtIndex:0];
            CALayer *border = [sticker.layer.sublayers objectAtIndex:1];
            pan.opacity = 0;
            border.opacity = 0;
        }
    }
    return self.avatarImageView;
}

- (void)removeNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
