//
//  TextToolViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 10.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "TextToolViewController.h"
#import "TextView.h"
#import "ColorPaletteForTextView.h"
#import "UIColor+Category.h"
#import "Constants.h"
#import "CropViewController.h"
#import "StickersViewController.h"
#import "DoodleViewController.h"
#import "FiltersViewController.h"
#import "StickerView.h"
#import "UIColor+Category.h"

NSString* const TextToCropNotification = @"TextToCropNotification";
NSString* const TextToStickerNotification = @"TextToStickerNotification";
NSString* const TextToDoodleNotification = @"TextToDoodleNotification";
NSString* const TextToFilterNotification = @"TextToFilterNotification";

NSString* const TextImageUserInfoKey = @"TextImageUserInfoKey";
NSString* const TextSubviewsUserInfoKey = @"TextSubviewsUserInfoKey";

@interface TextToolViewController ()

@property (strong, nonatomic) TextView *textView;
@property (strong, nonatomic) ColorPaletteForTextView *colorPalette;
@property (strong, nonatomic) UIImageView *trashImageViewFirstPart;
@property (strong, nonatomic) UIImageView *trashImageViewSecondPart;
@property (assign, nonatomic) CGRect newFrameToOpenTrash;
@property (assign, nonatomic) CGRect newFrameToCloseTrash;
@property (strong, nonatomic) UIButton *doneButton;
@property (assign, nonatomic) CGSize oldContentSize;
@property (strong, nonatomic) UIImage *cropUncroppedOriginal;
@property (strong, nonatomic) UIImage *cropCroppedScaledOriginal;
@property (strong, nonatomic) UIImage *filteredUncroppedImage;

@end

@implementation TextToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StickerToTextNotification:) name:StickerToTextNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoodleToTextNotification:) name:DoodleToTextNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FilterToTextNotification:) name:FilterToTextNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CropToTextNotification:) name:CropToTextNotification object:nil];

    self.avatarImageView.userInteractionEnabled = YES;
    self.avatarImageView.clipsToBounds = YES;
    [self addConstraintToTrashView:self.trashView toAvatarImageView:self.avatarImageView andToLayerView:self.layerView];
    [self addConstraintsToButton:self.addTextButton andToTrashView:self.trashView];
    [self configureNotifications];
    
    [self configureTrashView];
    [self.layerView bringSubviewToFront:self.avatarImageView];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSMutableArray *subviewsArray = [NSMutableArray array];
    
    for (UIView *view in self.avatarImageView.subviews) {
        if ([view isKindOfClass:[TextView class]]) {
            TextView *textView = (TextView*)view;
            textView.editable = NO;
            textView.selectable = NO;
        }
        [subviewsArray addObject:view];
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                subviewsArray, TextSubviewsUserInfoKey,
                                self.avatarImageView.image, TextImageUserInfoKey,
                                self.cropUncroppedOriginal, CropUncroppedImageUserInfoKey,
                                self.cropCroppedScaledOriginal, CropCroppedOriginalScaledUserInfoKey,
                                self.filteredUncroppedImage, FilterEditedFullSizePhotoUserInfoKey,
                                nil];
    
    switch (self.selectedController) {
            
        case CropTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:TextToCropNotification object:nil userInfo:dictionary];
            break;
        case StickersTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:TextToStickerNotification object:nil userInfo:dictionary];
            break;
        case FiltersTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:TextToFilterNotification object:nil userInfo:dictionary];
            break;
        case DoodleTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:TextToDoodleNotification object:nil userInfo:dictionary];
            break;
        case TextTool:
            
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

- (void) addConstraintsToButton:(UIButton*)addTextButton andToTrashView:(UIView*)trashView {
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:addTextButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:trashView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:addTextButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:trashView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *equalHeight = [NSLayoutConstraint constraintWithItem:addTextButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:trashView attribute:NSLayoutAttributeHeight multiplier:0.35 constant:0];
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:addTextButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:addTextButton attribute:NSLayoutAttributeWidth multiplier:1/1 constant:0];
    [trashView addConstraint:centerX];
    [trashView addConstraint:centerY];
    [trashView addConstraint:equalHeight];
    [addTextButton addConstraint:aspectRatio];
    
    addTextButton.translatesAutoresizingMaskIntoConstraints = NO;
}


#pragma mark - Notifications


- (void) DoodleToTextNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *subviewsArray = [dictionary objectForKey:DoodleSubviewsUserInfoKey];
    self.avatarImageView.image = [dictionary objectForKey:DoodleImageUserInfoKey];
    self.cropUncroppedOriginal = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.cropCroppedScaledOriginal = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    self.filteredUncroppedImage = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
    [self prepareSubviews:subviewsArray];
    
}

- (void) CropToTextNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    self.avatarImageView.image = [dictionary objectForKey:CroppedImageUserInfoKey];
    NSArray *subviewsArray = [dictionary objectForKey:CropSubviewsArrayUserInfoKey];
    self.cropUncroppedOriginal = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.cropCroppedScaledOriginal = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    self.filteredUncroppedImage = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];

    [self prepareSubviews:subviewsArray];
    
}
- (void) StickerToTextNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    NSArray *subviewsArray = [dictionary objectForKey:StickerSubviewsUserInfoKey];
    self.avatarImageView.image = [dictionary objectForKey:StickerImageUserInfoKey];
    self.cropUncroppedOriginal = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.cropCroppedScaledOriginal = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    self.filteredUncroppedImage = [dictionary objectForKey:FilterEditedFullSizePhotoUserInfoKey];
    
   [self prepareSubviews:subviewsArray];
}
- (void) FilterToTextNotification:(NSNotification*)notification {
    
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
        if ([view isKindOfClass:[TextView class]]) {
            self.avatarImageView.clipsToBounds = YES;
            TextView *textView = (TextView*)view;
            textView.trashViewDelegate = self;
            textView.editable = YES;
            textView.selectable = YES;
            [self.avatarImageView addSubview:textView];
            
            
        }
        
        if ([view isKindOfClass:[StickerView class]]) {
            StickerView *sticker = (StickerView*)view;
            sticker.delegate = self;
            [self.avatarImageView addSubview:view];
        }
        if ([view isKindOfClass:[DoodleView class]]) {
            
            [self.avatarImageView addSubview:view];
        }
    }

}

- (void) configureNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}


- (void) notificationKeyboardWillShow:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    CGSize keyboardSize = [[dictionary objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat buttomOriginY = self.avatarImageView.frame.origin.y + self.avatarImageView.frame.size.height;
    CGFloat keyboardOriginY = self.layerView.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height
                            + self.navigationController.navigationBar.frame.size.height - keyboardSize.height;
    CGFloat offset = buttomOriginY - keyboardOriginY;
    
    self.textView.scrollEnabled = YES;
    
    CGRect newFrame = CGRectMake(CGRectGetMinX(self.avatarImageView.bounds), CGRectGetMinY(self.avatarImageView.bounds) - offset - 10,
                                 CGRectGetMaxX(self.avatarImageView.bounds), CGRectGetMaxY(self.avatarImageView.bounds));
    self.textView.frame = newFrame;
    
    
    self.navigationController.navigationBarHidden = YES;
    
    [self configureColorPaletteWithHeight:[UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - keyboardSize.height];
    [self configureDoneButton];
    
    self.colorPalette.delegate = self.textView;
    self.textView.trashViewDelegate = self;
    
}



- (void) notificationKeyboardWillHide:(NSNotification*)notification {
    
      
    [self.colorPalette removeFromSuperview];
    self.colorPalette = nil;
    [self.doneButton removeFromSuperview];
    self.doneButton = nil;
    self.navigationController.navigationBarHidden = NO;
    
   
    [self resizeTextView];
    
    if ([self.textView.text isEqualToString:EMPTY]) {
        [self.textView removeFromSuperview];
        self.textView = nil;
    }
    self.textView.scrollEnabled = NO;
    
}



- (void) resizeTextView {
    
    CGFloat maxWidth = self.avatarImageView.bounds.size.width;
    CGFloat maxHeight = self.avatarImageView.bounds.size.height;
    
    CGRect newFrame = [self sizeThatFitWithWidth:FLT_MAX height:FLT_MAX avatarBounds:self.avatarImageView.bounds];
    CGRect resultFrame = newFrame;
    
    if (newFrame.size.width > self.avatarImageView.bounds.size.width) {
        
        resultFrame = [self sizeThatFitWithWidth:maxWidth height:FLT_MAX avatarBounds:self.avatarImageView.bounds];
   
    }
    if (newFrame.size.height > self.avatarImageView.bounds.size.height) {
        
        resultFrame = [self sizeThatFitWithWidth:FLT_MAX height:maxHeight avatarBounds:self.avatarImageView.bounds];
    }
    if (newFrame.size.width > self.avatarImageView.bounds.size.width && newFrame.size.height > self.avatarImageView.bounds.size.height) {
        
        resultFrame = [self sizeThatFitWithWidth:maxWidth height:maxHeight avatarBounds:self.avatarImageView.bounds];
    }
    
    self.textView.frame = resultFrame;
}

- (CGRect) sizeThatFitWithWidth:(CGFloat)width height:(CGFloat)height avatarBounds:(CGRect)bounds {
    
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(width, height)];
    CGRect newFrame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, newSize.height), newSize.height);
    newFrame.origin.x = (bounds.size.width - newFrame.size.width) / 2;
    newFrame.origin.y = (bounds.size.height - newFrame.size.height) / 2;
    
    return newFrame;
}

- (void) configureTextView {
    
    self.textView = [[TextView alloc] initWithFrame:self.avatarImageView.bounds];
    [self.avatarImageView addSubview:self.textView];
    
    self.textView.trashView = self.trashView;
    
    
    
     [self.layerView bringSubviewToFront:self.avatarImageView];
}

- (void) configureColorPaletteWithHeight:(CGFloat)fixedHeigth {
    
    
    self.colorPalette = [[ColorPaletteForTextView alloc] initWithFrame:CGRectNull];
    [self.layerView addSubview:self.colorPalette];
    [self.layerView bringSubviewToFront:self.colorPalette];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.colorPalette attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.layerView attribute:NSLayoutAttributeTop multiplier:1 constant:[UIApplication sharedApplication].statusBarFrame.size.height];
    NSLayoutConstraint *heigth = [NSLayoutConstraint constraintWithItem:self.colorPalette attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:fixedHeigth];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.colorPalette attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 45];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.colorPalette attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.layerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    
    [self.layerView addConstraint:top];
    [self.colorPalette addConstraint:heigth];
    [self.colorPalette addConstraint:width];
    [self.layerView addConstraint:trailing];
    
    self.colorPalette.translatesAutoresizingMaskIntoConstraints = NO;
    
}

- (void) configureDoneButton {
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.doneButton.frame = CGRectMake(0, 0, 50, 25);
    [self.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = [UIFont systemFontOfSize:self.doneButton.frame.size.height / 1.5];
    self.doneButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
    self.doneButton.layer.cornerRadius = 12;
    [self.layerView addSubview:self.doneButton];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.doneButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.layerView attribute:NSLayoutAttributeTop multiplier:1 constant:[UIApplication sharedApplication].statusBarFrame.size.height];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.doneButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.layerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-[UIScreen mainScreen].bounds.size.width / 10];
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:self.doneButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.doneButton attribute:NSLayoutAttributeHeight multiplier:2/1 constant:0];
    NSLayoutConstraint *equalWidth = [NSLayoutConstraint constraintWithItem:self.doneButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.layerView attribute:NSLayoutAttributeWidth multiplier:0.2 constant:0];
    
    [self.layerView addConstraint:top];
    [self.layerView addConstraint:trailing];
    [self.doneButton addConstraint:aspectRatio];
    [self.layerView addConstraint:equalWidth];
    
    self.doneButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) configureTrashView {
    
    self.trashView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.trashView.layer.borderWidth = 0;
    self.trashView.backgroundColor = [UIColor clearColor];
    self.trashImageViewFirstPart = [[UIImageView alloc] init];
    self.trashImageViewFirstPart.image = [UIImage imageNamed:@"trashForStickers_firstPart.png"];
    self.trashImageViewSecondPart = [[UIImageView alloc] init];
    self.trashImageViewSecondPart.image = [UIImage imageNamed:@"trashForStickers_secondPart.png"];
    
    [self.trashView addSubview:self.trashImageViewFirstPart];
    [self.trashView addSubview:self.trashImageViewSecondPart];
    
    
    
    
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
    
    trashImageViewFirstPart.hidden = YES;
    trashImageViewSecondPart.hidden = YES;
    
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

#pragma mark - Trash view protocol

- (void) hideTrashView {
    
    self.addTextButton.hidden = NO;
    self.trashImageViewFirstPart.hidden = YES;
    self.trashImageViewSecondPart.hidden = YES;
    self.trashView.backgroundColor = [UIColor clearColor];
    self.trashView.layer.borderWidth = 0;
    [self.trashImageViewSecondPart.layer removeAllAnimations];
    self.trashImageViewSecondPart.transform = CGAffineTransformIdentity;
    self.trashImageViewSecondPart.frame = self.newFrameToCloseTrash;
}
- (void) showTrashView {
    
    [self configureFirstPartOfTrashImageView:self.trashImageViewFirstPart andSecondPartOfTrashView:self.trashImageViewSecondPart withTrashView:self.trashView andWithOffset:3];
    self.addTextButton.hidden = YES;
    self.trashImageViewFirstPart.hidden = NO;
    self.trashImageViewSecondPart.hidden = NO;
    self.trashView.backgroundColor = [UIColor color_forCropView];
    self.trashView.layer.borderWidth = 1;
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
                         
                         self.trashImageViewSecondPart.frame = self.newFrameToOpenTrash;
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
- (void) animateDelete:(UITextView*)objectToDelete {
    
    [objectToDelete.layer removeAllAnimations];
    
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
                         
                     }];

    
}
- (void) transformObjectToReadyToDelete:(UIView*)view {
    
    CALayer *panAnimationLayer = [view.layer.sublayers objectAtIndex:0];
    
    float percentDeltaHeight = 100 * ((panAnimationLayer.frame.size.height - self.trashView.frame.size.height) / panAnimationLayer.frame.size.height);
    
   
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

- (IBAction)doneButtonAction:(UIButton *)sender {
    
    [self.textView resignFirstResponder];
}

- (IBAction)addTextButtonAction:(UIButton *)sender {
    
    
    [self configureTextView];
    [self.textView becomeFirstResponder];
    
}

- (void)removeNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
