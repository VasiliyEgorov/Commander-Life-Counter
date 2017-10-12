//
//  CropViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 09.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CropViewController.h"
#import "UIColor+Category.h"
#import "UIImage+Category.h"
#import "StickersViewController.h"
#import "DoodleViewController.h"
#import "TextToolViewController.h"
#import "FiltersViewController.h"
#import "StickerView.h"
#import "DoodleView.h"
#import "TextView.h"


#define IMAGEWIDTH_MORETHEN_HEIGHT self.avatarImageView.image.size.width > self.avatarImageView.image.size.height

NSString* const CropToStickerNotification = @"CropToStickerNotification";
NSString* const CropToDoodleNotification = @"CropToDoodleNotification";
NSString* const CropToTextNotification = @"CropToTextNotification";
NSString* const CropToFilterNotification = @"CropToFilterNotification";

NSString* const CroppedImageUserInfoKey = @"CroppedImageUserInfoKey";
NSString* const CropSubviewsArrayUserInfoKey = @"CropSubviewsArrayUserInfoKey";
NSString* const CropUncroppedImageUserInfoKey = @"CropUncroppedImageUserInfoKey";
NSString* const CropCroppedOriginalScaledUserInfoKey = @"CropCroppedOriginalScaledUserInfoKey";

@interface CropViewController ()

@property (strong, nonatomic) CropData *cropData;
@property (strong, nonatomic) UIView *cropView;
@property (strong, nonatomic) UIView *leftAvatarDimView;
@property (strong, nonatomic) UIView *rightAvatarDimView;
@property (assign, nonatomic) CGFloat offsetX;
@property (assign, nonatomic) CGFloat offsetY;
@property (assign, nonatomic) CGRect *temp;


@end

@implementation CropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cropData = [[CropData alloc] init];
    self.cropData.delegate = self;
    
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextToCropNotification:) name:TextToCropNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoodleToCropNotification:) name:DoodleToCropNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FilterToCropNotification:) name:FilterToCropNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StickerToCropNotification:) name:StickerToCropNotification object:nil];
    
    [self configureScrollViewConstraintsDependsOnPhotoSize:self.originalPhoto];
    
    
    self.avatarImageView = [UIImageView new];
    self.avatarImageView.clipsToBounds = YES;
    [self.cropData makeNewScaleForPhoto:self.originalPhoto andMakeNewFrameForAvatarImageView:self.avatarImageView];
    
    [self.scrollView addSubview:self.avatarImageView];
    
    self.cropView = [UIView new];
    
    self.cropView.layer.borderWidth = 1;
    self.cropView.layer.borderColor = [UIColor color_forCropView].CGColor;
    
    
    
    
    [self.scrollView addSubview:self.cropView];
    
    self.leftAvatarDimView = [UIView new];
    self.rightAvatarDimView = [UIView new];
    self.leftAvatarDimView.backgroundColor = [UIColor color_DimsCropView:0.4];
    self.rightAvatarDimView.backgroundColor = [UIColor color_DimsCropView:0.4];
    [self.scrollView addSubview:self.leftAvatarDimView];
    [self.scrollView addSubview:self.rightAvatarDimView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.cropData makeStartScrollViewInsetContentSizeAndInsetImageView:self.avatarImageView];
    
    [self.cropData makeNewFrameForCropViewWithScrollViewFrame:self.scrollView];
    
    
    [self.cropData updateDimViewsFrames:self.leftAvatarDimView rightDim:self.rightAvatarDimView depeningOnCropView:self.cropView andAvatarImageView:self.avatarImageView];
    
    [self scroll:self.scrollView toCropView:self.cropView];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   

    UIImage *croppedImage = [UIImage cropImage:self.avatarImageView.image byCropViewFrames:self.cropView.frame];
    UIImage *originalScaledCropped = [UIImage cropImage:self.originalPhoto byCropViewFrames:self.cropView.frame];
    NSMutableArray *avatarSubviews = [NSMutableArray array];
    
    for (UIView *view in self.avatarImageView.subviews) {
        [avatarSubviews addObject:view];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (UIView *avatarView in avatarSubviews) {
       
  
            if ((avatarView.frame.origin.x + avatarView.frame.size.width >= self.cropView.frame.origin.x &&
                 avatarView.frame.origin.x <= self.cropView.frame.origin.x + self.cropView.frame.size.width) &&
                (avatarView.frame.origin.y + avatarView.frame.size.height >= self.cropView.frame.origin.y &&
                 avatarView.frame.origin.y <= self.cropView.frame.origin.y + self.cropView.frame.size.height)) {
                
                if ([avatarView isMemberOfClass:[UIView class]]) {
                    
                    avatarView.frame = [self scaleBackView:avatarView];
                    
                    TextView *textView = [avatarView.subviews objectAtIndex:0];
                    
                    textView.frame = avatarView.frame;
                    [avatarView removeFromSuperview];
    
                    [array addObject:textView];
                }
                if ([avatarView isKindOfClass:[StickerView class]]) {
                    
                    avatarView.frame = [self scaleBackView:avatarView];
                    
                    [array addObject:avatarView];

                }
                if ([avatarView isKindOfClass:[DoodleView class]]) {
                    
                    avatarView.frame = [self scaleBackView:avatarView];
                    
                    [array addObject:avatarView];
                }
                
            }
        }
        
    
    
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                croppedImage, CroppedImageUserInfoKey,
                                array, CropSubviewsArrayUserInfoKey,
                                self.originalPhoto, CropUncroppedImageUserInfoKey,
                                originalScaledCropped, CropCroppedOriginalScaledUserInfoKey,
                                nil];
    
    
    switch (self.selectedController) {
            
        case StickersTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:CropToStickerNotification object:nil userInfo:dictionary];
            break;
        case TextTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:CropToTextNotification object:nil userInfo:dictionary];
            break;
        case FiltersTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:CropToFilterNotification object:nil userInfo:dictionary];
            break;
        case DoodleTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:CropToDoodleNotification object:nil userInfo:dictionary];
            break;
        case CropTool:
            
            break;
    }
  
   
}

#pragma mark - Notifications


- (void) TextToCropNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *imageViewSubviews = [dictionary objectForKey:TextSubviewsUserInfoKey];
    
    UIImage *image = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
    if (image) {
        self.avatarImageView.image = image;
    }
    
    [self prepareSubviewsToSubview:imageViewSubviews];
    
}

- (void) StickerToCropNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *imageViewSubviews = [dictionary objectForKey:StickerSubviewsUserInfoKey];
    
    UIImage *image = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
    if (image) {
        self.avatarImageView.image = image;
    }
    
    [self prepareSubviewsToSubview:imageViewSubviews];
    
}
- (void) DoodleToCropNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *imageViewSubviews = [dictionary objectForKey:DoodleSubviewsUserInfoKey];
    
    UIImage *image = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
    if (image) {
        self.avatarImageView.image = image;
    }
    
    [self prepareSubviewsToSubview:imageViewSubviews];
    
}
- (void) FilterToCropNotification:(NSNotification*)notification {
    
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *imageViewSubviews = [dictionary objectForKey:FilterSubviewsUserInfoKey];
    
    UIImage *image = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
    if (image) {
        self.avatarImageView.image = image;
    }
 
    [self prepareSubviewsToSubview:imageViewSubviews];
    
}



- (void) prepareSubviewsToSubview:(NSArray*)avatarImageView {
    

    for (UIView *view in avatarImageView) {
        if ([view isKindOfClass:[StickerView class]]) {
            StickerView *sticker = (StickerView*)view;
            for (UIImageView *imageSticker in sticker.subviews) {
                
                [view addSubview:imageSticker];
            }
            view.frame = [self scaleView:view];
             [self.avatarImageView addSubview:view];
        }
        if ([view isKindOfClass:[TextView class]]) {
            TextView *textView = (TextView*)view;
            UIView *layerView = [[UIView alloc] initWithFrame:textView.frame];
            [layerView addSubview:textView];
            CGRect newFrame = CGRectMake(0, 0, textView.frame.size.width, textView.frame.size.height);
            textView.frame = newFrame;
            
            layerView.frame = [self scaleView:layerView];
            
            [self.avatarImageView addSubview:layerView];
            
        }

        
        if ([view isKindOfClass:[DoodleView class]]) {
            
            view.frame = [self scaleView:view];
            [self.avatarImageView addSubview:view];
        }
        
        
    }
    
}


- (CGRect) scaleView:(UIView*)view {
    
    float findDeltaFromMore = 100.0 * ([UIScreen mainScreen].bounds.size.width - self.cropView.frame.size.width) / [UIScreen mainScreen].bounds.size.width;
    
    int adjustLocationX = roundf(view.frame.origin.x - (view.frame.origin.x * findDeltaFromMore / 100));
    int adjustLocationY = roundf(view.frame.origin.y - (view.frame.origin.y * findDeltaFromMore / 100));
    
    
    view.transform = CGAffineTransformMakeScale(1 - (findDeltaFromMore / 100), 1 - (findDeltaFromMore / 100));
    
    
    view.frame = CGRectMake(self.cropView.frame.origin.x + adjustLocationX,
                            self.cropView.frame.origin.y + adjustLocationY,
                            view.frame.size.width, view.frame.size.height);
    return view.frame;
}

- (CGRect) scaleBackView:(UIView*)view {
    
    float findDeltaFromLess = 100.0 * (self.cropView.frame.size.width - [UIScreen mainScreen].bounds.size.width ) / self.cropView.frame.size.width;
    
    float deltaBetweenCropXAndAvatarImageViewX = fabs(self.cropView.frame.origin.x - self.avatarImageView.frame.origin.x);
    float deltaBetweenCropYAndAvatarImageViewY = fabs(self.cropView.frame.origin.y - self.avatarImageView.frame.origin.y);
    
    float adjustLocationX = view.frame.origin.x - deltaBetweenCropXAndAvatarImageViewX -
    ((view.frame.origin.x - deltaBetweenCropXAndAvatarImageViewX) * findDeltaFromLess / 100);
    
    float adjustLocationY = view.frame.origin.y - deltaBetweenCropYAndAvatarImageViewY -
    ((view.frame.origin.y - deltaBetweenCropYAndAvatarImageViewY) * findDeltaFromLess / 100);
    
    view.transform = CGAffineTransformIdentity;
    
    int resultX = roundf(adjustLocationX);
    int resultY = roundf(adjustLocationY);
   
    
    CGRect newFrame = CGRectMake(resultX, resultY, view.frame.size.width, view.frame.size.height);
    view.frame = newFrame;
    
    return view.frame;
}




- (IBAction)doneButtonAction:(UIBarButtonItem *)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Constraints

- (void) configureScrollViewConstraintsDependsOnPhotoSize:(UIImage*) photo {
   
     self.scrollViewTopConstraint.constant = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
     self.rotateButtonLayersBottomConstraint.constant = self.tabBarController.tabBar.frame.size.height;
    
    CGFloat percentDeltaBetween3on4RatioWith16on9 = 43.75;
        
    if (photo.size.width < photo.size.height) {
        
        self.scrollViewLeadingConstraint.constant = 22;
        self.scrollViewTrailingConstraint.constant = 22;

        CGFloat percentDelta = 100 * ((photo.size.width - photo.size.height) / photo.size.width);
        NSInteger result = fabs(percentDelta);
        
        if (result < percentDeltaBetween3on4RatioWith16on9) {
            
            UIImage *scaled = [UIImage scaleImage:photo toFrame:CGRectMake(0, 0,
                                                                           [UIScreen mainScreen].bounds.size.width - self.scrollViewLeadingConstraint.constant - self.scrollViewTrailingConstraint.constant, 0)];
            CGFloat newScrollViewHeight = scaled.size.height - 1;
            CGFloat newScrollViewTopContraint = [UIScreen mainScreen].bounds.size.height - self.scrollViewButtomConstraint.constant
                                                - newScrollViewHeight - self.scrollViewTopConstraint.constant;
            self.scrollViewTopConstraint.constant = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height + newScrollViewTopContraint;
        }
        
        
    } else {
        
        self.scrollViewLeadingConstraint.constant = 0;
        self.scrollViewTrailingConstraint.constant = 0;
    }
    

    [self.view updateConstraintsIfNeeded];
}



#pragma mark EditAvatarAndCrop Protocol

- (void) calculateOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY andCropViewFrame:(CGRect)frame {
    
    self.offsetX = offsetX;
    self.offsetY = offsetY;
    self.cropView.frame = frame;
    
}
- (void) calculateScrollViewContentSize:(CGSize)contentSize andContentInset:(UIEdgeInsets)inset {
    
    [self.scrollView setContentSize:contentSize];
    [self.scrollView setContentInset:inset];
}
- (void) scalePhoto:(UIImage*)image andSetFrameForAvatarImageView:(CGRect)newFrame {
    
    self.avatarImageView.image = image;
    self.avatarImageView.frame = newFrame;
    
    self.originalPhoto = self.avatarImageView.image;
}
- (void) calculateDynamicallyScrollViewContentInset:(UIEdgeInsets)contentInset {
    
    [self.scrollView setContentInset:contentInset];
    
}
- (void) calculateLeftDimViewFrame:(CGRect)leftDimViewFrame andForRightDimView:(CGRect)rightDimViewFrame {
    
    self.leftAvatarDimView.frame = leftDimViewFrame;
    self.rightAvatarDimView.frame = rightDimViewFrame;
    
}
- (void) rotatedAvatarImageView:(UIImage*)image newFrameForAvatarImageView:(CGRect)newFrame rotatedOriginal:(UIImage*)original {
    
    for (UIView *view in self.avatarImageView.subviews) {
        
        CGRect newFrame = CGRectMake(view.frame.origin.y, view.frame.origin.x, view.frame.size.width, view.frame.size.height);
        view.frame = newFrame;
    }
    
    self.avatarImageView.frame = newFrame;
    self.avatarImageView.image = image;
    self.avatarImageView.alpha = 0;
    self.originalPhoto = original;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.avatarImageView.alpha = 1;
                     }];
    
    
    
    
}


- (void) scroll:(UIScrollView*)scrollView toCropView:(UIView*)cropView {
    
    if (IMAGEWIDTH_MORETHEN_HEIGHT) {
        
        CGFloat newInsetX = cropView.frame.origin.x + self.offsetX;
        [scrollView scrollRectToVisible:[self makeScrollInset:newInsetX insetY:0] animated:NO];
    } else {
        
        CGFloat newInsetY = cropView.frame.origin.y + self.offsetY;
        
        [scrollView scrollRectToVisible:[self makeScrollInset:0 insetY:newInsetY] animated:NO];
        
    }
    
}

- (CGRect) makeScrollInset:(CGFloat)insetX insetY:(CGFloat)insetY {
    
    CGRect rect = CGRectMake(insetX, insetY, self.cropView.frame.size.width, self.cropView.frame.size.height);
    return rect;
}



#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat newPosition;
    CGRect newFrame;
    
    if (IMAGEWIDTH_MORETHEN_HEIGHT) {
        
        newPosition = self.scrollView.contentOffset.x + self.offsetX;
        
        newFrame = CGRectMake(newPosition, self.cropView.frame.origin.y, self.cropView.frame.size.width, self.cropView.frame.size.height);
        
        self.cropView.frame = newFrame;
        
    }
    else {
        
        newPosition = self.scrollView.contentOffset.y + self.offsetY;
        
        newFrame = CGRectMake(self.cropView.frame.origin.x, newPosition, self.cropView.frame.size.width, self.cropView.frame.size.height);
        
        self.cropView.frame = newFrame;
        
    }
    
    [self.cropData makeNewInsetIn:scrollView forView:self.cropView withOffsetX:self.offsetX andOffsetY:self.offsetY dependingOnAvatarImageView:self.avatarImageView];
    [self.cropData updateDimViewsFrames:self.leftAvatarDimView rightDim:self.rightAvatarDimView depeningOnCropView:self.cropView andAvatarImageView:self.avatarImageView];
}


#pragma mark - Actions

- (IBAction)rotateButtonAction:(UIBarButtonItem *)sender {
    
    
   [self.cropData rotateAvatarImageView:self.avatarImageView andOriginalPhoto:self.originalPhoto];
 
    [self configureScrollViewConstraintsDependsOnPhotoSize:self.avatarImageView.image];
    
    [self.view layoutIfNeeded];
    
}


#pragma mark - Save 

- (UIImageView*) prepareToSave {
    
    UIImage *croppedImage = [UIImage cropImage:self.avatarImageView.image byCropViewFrames:self.cropView.frame];
    
    UIImageView *result = [[UIImageView alloc] initWithImage:croppedImage];
    
    for (UIView *avatarView in self.avatarImageView.subviews) {
        
        
        if ((avatarView.frame.origin.x + avatarView.frame.size.width >= self.cropView.frame.origin.x &&
             avatarView.frame.origin.x <= self.cropView.frame.origin.x + self.cropView.frame.size.width) &&
            (avatarView.frame.origin.y + avatarView.frame.size.height >= self.cropView.frame.origin.y &&
             avatarView.frame.origin.y <= self.cropView.frame.origin.y + self.cropView.frame.size.height)) {
               
                
                if ([avatarView isMemberOfClass:[UIView class]]) {
                    
                    avatarView.frame = [self scaleBackView:avatarView];
                    
                    TextView *textView = [avatarView.subviews objectAtIndex:0];
                    
                    textView.frame = avatarView.frame;
                    [avatarView removeFromSuperview];
                    
                    [result addSubview:textView];
                }
                if ([avatarView isKindOfClass:[StickerView class]]) {
                    
                    avatarView.frame = [self scaleBackView:avatarView];
                    
                    [result addSubview:avatarView];
                    
                }
                if ([avatarView isKindOfClass:[DoodleView class]]) {
                    
                    avatarView.frame = [self scaleBackView:avatarView];
                    
                    [result addSubview:avatarView];
                }
                
                
                
            }
    }
  
    return result;
}

- (void)removeNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
