//
//  FiltersViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 12.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "FiltersViewController.h"
#import "FiltersData.h"
#import "FiltersCollectionViewCell.h"
#import "CropViewController.h"
#import "StickersViewController.h"
#import "DoodleViewController.h"
#import "TextToolViewController.h"
#import "UIColor+Category.h"

NSString* const FilterToCropNotification = @"FilterToCropNotification";
NSString* const FilterToStickerNotification = @"FilterToStickerNotification";
NSString* const FilterToTextNotification = @"FilterToTextNotification";
NSString* const FilterToDoodleNotification = @"FilterToFilterNotification";

NSString* const FilterImageUserInfoKey = @"FilterImageUserInfoKey";
NSString* const FilterSubviewsUserInfoKey = @"FilterSubviewsUserInfoKey";
NSString* const FilterEditedFullSizePhotoUserInfoKey = @"FilterEditedFullSizePhotoUserInfoKey";

typedef NS_ENUM (NSUInteger, SelectedFilter) {
    originalPhoto,
    noirPhoto,
    sepiaPhoto,
    fadePhoto,
    instantPhoto,
    posterizePhoto
};


static NSString * const identifier = @"FiltersCell";

@interface FiltersViewController () 

@property (strong, nonatomic) FiltersData *filtersData;

@property (assign, nonatomic) SelectedFilter selectedFilter;

@property (strong, nonatomic) NSArray *buttonImagesArray;
@property (strong, nonatomic) NSArray *selectorsArray;
@property (strong, nonatomic) NSArray *textArray;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat top;
@property (assign, nonatomic) CGFloat bottom;
@property (strong, nonatomic) UIImage *croppedOriginalScaledPhoto;
@property (strong, nonatomic) UIImage *uncroppedOriginalPhoto;
@property (strong, nonatomic) NSIndexPath *selectedPath;

@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StickerToFilterNotification:) name:StickerToFilterNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DoodleToFilterNotification:) name:DoodleToFilterNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextToFilterNotification:) name:TextToFilterNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CropToFilterNotification:) name:CropToFilterNotification object:nil];
    
    [self addConstraintToCollectionLayerView:self.collectionLayerView toAvatarImageView:self.avatarImageView andToLayerView:self.layerView];
    [self addConstraintsToCollectionView:self.collectionView andToCollectionLayerView:self.collectionLayerView];
    self.avatarImageView.clipsToBounds = YES;
     
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"FiltersCollectionViewCellXIB" bundle:nil] forCellWithReuseIdentifier:identifier];
    
    self.filtersData = [[FiltersData alloc] init];
    
    
    
    
    self.selectorsArray = @[NSStringFromSelector(@selector(originalPhotoFilterAction:)),
                            NSStringFromSelector(@selector(noirPhotoFilterAction:)),
                            NSStringFromSelector(@selector(sepiaPhotoFilterAction:)),
                            NSStringFromSelector(@selector(fadePhotoFilterAction:)),
                            NSStringFromSelector(@selector(instantPhotoFilterAction:)),
                            NSStringFromSelector(@selector(posterizePhotoFilterAction:))];
    
    self.textArray = @[@"Original",
                       @"Noir",
                       @"Sepia",
                       @"Fade",
                       @"Instant",
                       @"Posterize"];
    
   
   self.selectedPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.height = self.collectionView.frame.size.height * 0.8;
    self.width = self.height * 0.8;
    self.top = (self.collectionView.frame.size.height * 0.2) / 2;
    self.bottom = self.top;
    
}



- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSMutableArray *subviewsArray = [NSMutableArray array];
    
    for (UIView *view in self.avatarImageView.subviews) {
        [subviewsArray addObject:view];
    }

    UIImage *uncroppedEditedImage; 
    
    
    switch (self.selectedFilter) {
        case originalPhoto:
            uncroppedEditedImage = self.uncroppedOriginalPhoto;
            break;
        case noirPhoto:
            uncroppedEditedImage = [self.filtersData noirFilerWithImage:self.uncroppedOriginalPhoto];
            break;
        case sepiaPhoto:
            uncroppedEditedImage = [self.filtersData sepiaFilerWithImage:self.uncroppedOriginalPhoto];
            break;
        case fadePhoto:
            uncroppedEditedImage = [self.filtersData fadeFilerWithImage:self.uncroppedOriginalPhoto];
            break;
        case instantPhoto:
            uncroppedEditedImage = [self.filtersData instantFilerWithImage:self.uncroppedOriginalPhoto];
            break;
        case posterizePhoto:
            uncroppedEditedImage = [self.filtersData posterizeFilerWithImage:self.uncroppedOriginalPhoto];
            break;
        default:
            uncroppedEditedImage = self.uncroppedOriginalPhoto;
            break;
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                subviewsArray, FilterSubviewsUserInfoKey,
                                self.avatarImageView.image, FilterImageUserInfoKey,
                                uncroppedEditedImage, FilterEditedFullSizePhotoUserInfoKey,
                                self.uncroppedOriginalPhoto, CropUncroppedImageUserInfoKey,
                                self.croppedOriginalScaledPhoto, CropCroppedOriginalScaledUserInfoKey,
                                nil];
    
    switch (self.selectedController) {
            
        case CropTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:FilterToCropNotification object:nil userInfo:dictionary];
            break;
        case StickersTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:FilterToStickerNotification object:nil userInfo:dictionary];
            break;
        case TextTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:FilterToTextNotification object:nil userInfo:dictionary];
            break;
        case DoodleTool:
            [[NSNotificationCenter defaultCenter] postNotificationName:FilterToDoodleNotification object:nil userInfo:dictionary];
            break;
        case FiltersTool:
            
            break;
    }
    
}

#pragma mark - Constraints

- (void)addConstraintToCollectionLayerView:(UIView*)collectionLayerView toAvatarImageView:(UIImageView*)avatarImageView andToLayerView:(UIView*)layerView {
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:collectionLayerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:avatarImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:collectionLayerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:layerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:collectionLayerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:layerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:collectionLayerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:layerView attribute:NSLayoutAttributeBottom multiplier:1 constant:-self.tabBarController.tabBar.frame.size.height];
    
    [layerView addConstraint:top];
    [layerView addConstraint:leading];
    [layerView addConstraint:trailing];
    [layerView addConstraint:bottom];
    
    collectionLayerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

- (void) addConstraintsToCollectionView:(UIView*)collectionView andToCollectionLayerView:(UIView*)collectionLayerView {
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:collectionLayerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:collectionLayerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:collectionLayerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:collectionView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:collectionLayerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    [collectionLayerView addConstraint:top];
    [collectionLayerView addConstraint:bottom];
    [collectionLayerView addConstraint:leading];
    [collectionLayerView addConstraint:trailing];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
}


#pragma mark - Notifications


- (void) DoodleToFilterNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    self.avatarImageView.image = [dictionary objectForKey:DoodleImageUserInfoKey];
    NSArray *subviewsArray = [dictionary objectForKey:DoodleSubviewsUserInfoKey];
    self.uncroppedOriginalPhoto = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.croppedOriginalScaledPhoto = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    
    [self prepareSubviews:subviewsArray withCroppedOriginalScaledPhoto:self.croppedOriginalScaledPhoto andCroppedImage:self.avatarImageView.image];
    
}

- (void) CropToFilterNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    self.avatarImageView.image = [dictionary objectForKey:CroppedImageUserInfoKey];
    NSArray *subviewsArray = [dictionary objectForKey:CropSubviewsArrayUserInfoKey];
    self.uncroppedOriginalPhoto = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.croppedOriginalScaledPhoto = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    
    [self prepareSubviews:subviewsArray withCroppedOriginalScaledPhoto:self.croppedOriginalScaledPhoto andCroppedImage:self.avatarImageView.image];
}
- (void) StickerToFilterNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    self.avatarImageView.image = [dictionary objectForKey:StickerImageUserInfoKey];
    NSArray *subviewsArray = [dictionary objectForKey:StickerSubviewsUserInfoKey];
    self.uncroppedOriginalPhoto = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.croppedOriginalScaledPhoto = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    
    [self prepareSubviews:subviewsArray withCroppedOriginalScaledPhoto:self.croppedOriginalScaledPhoto andCroppedImage:self.avatarImageView.image];
}

- (void) TextToFilterNotification:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    self.avatarImageView.image = [dictionary objectForKey:TextImageUserInfoKey];
    NSArray *subviewsArray = [dictionary objectForKey:TextSubviewsUserInfoKey];
    self.uncroppedOriginalPhoto = [dictionary objectForKey:CropUncroppedImageUserInfoKey];
    self.croppedOriginalScaledPhoto = [dictionary objectForKey:CropCroppedOriginalScaledUserInfoKey];
    
    [self prepareSubviews:subviewsArray withCroppedOriginalScaledPhoto:self.croppedOriginalScaledPhoto andCroppedImage:self.avatarImageView.image];
}

- (void) prepareSubviews:(NSArray*)subviewsArray withCroppedOriginalScaledPhoto:(UIImage*)croppedOriginalScaledPhoto andCroppedImage:(UIImage*)croppedImage {
    
    self.buttonImagesArray = @[croppedOriginalScaledPhoto,
                               [self.filtersData noirFilerWithImage:croppedImage],
                               [self.filtersData sepiaFilerWithImage:croppedImage],
                               [self.filtersData fadeFilerWithImage:croppedImage],
                               [self.filtersData instantFilerWithImage:croppedImage],
                               [self.filtersData posterizeFilerWithImage:croppedImage]];
    
    [self.collectionView reloadData];
   
    
   
    for (UIView *view in subviewsArray) {
        [self.avatarImageView addSubview:view];
    }

}



#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.buttonImagesArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FiltersCollectionViewCell *filtersCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if ([indexPath isEqual:self.selectedPath]) {
       
        filtersCell.label.textColor = [UIColor color_forCropView];
    }
    else {
        filtersCell.label.textColor = [UIColor color_150withAlpha:1];
    }
    [filtersCell.button setBackgroundImage:[self.buttonImagesArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    [filtersCell.button addTarget:self action:NSSelectorFromString([self.selectorsArray objectAtIndex:indexPath.row]) forControlEvents:UIControlEventTouchUpInside];
    
    filtersCell.label.text = [self.textArray objectAtIndex:indexPath.row];
    
    return filtersCell;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

#pragma mark CollectionView delegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    FiltersCollectionViewCell *filtersCell = (FiltersCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([filtersCell.button respondsToSelector:NSSelectorFromString([self.selectorsArray objectAtIndex:indexPath.row])]) {
        [filtersCell.button sendAction:NSSelectorFromString([self.selectorsArray objectAtIndex:indexPath.row]) to:self forEvent:nil];
        
    }
}


#pragma mark - Flow delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGSize imageSize = CGSizeMake(self.width, self.height);
    
    return imageSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    
    
    return UIEdgeInsetsMake(self.top, 10, self.bottom, 10);
}

#pragma mark Actions

- (void) originalPhotoFilterAction:(UIButton*) button {
    
    self.selectedFilter = originalPhoto;
    self.avatarImageView.image = self.croppedOriginalScaledPhoto;
    [self selectCollectionViewItemOnButtonAction:button];
}
- (void) noirPhotoFilterAction:(UIButton*) button {
    
    self.selectedFilter = noirPhoto;
    self.avatarImageView.image = button.currentBackgroundImage;
    [self selectCollectionViewItemOnButtonAction:button];
}

- (void) sepiaPhotoFilterAction:(UIButton*) button {
    
    self.selectedFilter = sepiaPhoto;
    self.avatarImageView.image = button.currentBackgroundImage;
    [self selectCollectionViewItemOnButtonAction:button];
}

- (void) fadePhotoFilterAction:(UIButton*) button {
    
    self.selectedFilter = fadePhoto;
    self.avatarImageView.image = button.currentBackgroundImage;
    [self selectCollectionViewItemOnButtonAction:button];
}

- (void) instantPhotoFilterAction:(UIButton*) button {
    
    self.selectedFilter = instantPhoto;
    self.avatarImageView.image = button.currentBackgroundImage;
    [self selectCollectionViewItemOnButtonAction:button];
}

- (void) posterizePhotoFilterAction:(UIButton*) button {
    
    self.selectedFilter = posterizePhoto;
    self.avatarImageView.image = button.currentBackgroundImage;
    [self selectCollectionViewItemOnButtonAction:button];
}

- (void) selectCollectionViewItemOnButtonAction:(UIButton*)button {
  
    CGPoint buttonOrigin = button.frame.origin;
    CGPoint pointOncollectionView = [self.collectionView convertPoint:buttonOrigin fromView:button.superview];
    self.selectedPath = [self.collectionView indexPathForItemAtPoint:pointOncollectionView];
    
    [self.collectionView reloadData];
}

- (void)removeNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
