//
//  CropData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 31.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CropProtocol <NSObject>

- (void) calculateOffsetX:(CGFloat)offsetX offsetY:(CGFloat)offsetY andCropViewFrame:(CGRect)frame;
- (void) calculateScrollViewContentSize:(CGSize)contentSize andContentInset:(UIEdgeInsets)inset;
- (void) scalePhoto:(UIImage*)image andSetFrameForAvatarImageView:(CGRect)newFrame;
- (void) calculateDynamicallyScrollViewContentInset:(UIEdgeInsets)contentInset;
- (void) calculateLeftDimViewFrame:(CGRect)leftDimViewFrame andForRightDimView:(CGRect)rightDimViewFrame;
- (void) rotatedAvatarImageView:(UIImage*)image newFrameForAvatarImageView:(CGRect)newFrame rotatedOriginal:(UIImage*)original;

@end

@interface CropData : NSObject

@property (strong, nonatomic) id <CropProtocol> delegate;


- (void) makeNewFrameForCropViewWithScrollViewFrame:(UIScrollView*)scrollView;
- (void) makeStartScrollViewInsetContentSizeAndInsetImageView:(UIImageView*)avatarImageView;
- (void) makeNewScaleForPhoto:(UIImage*)photo andMakeNewFrameForAvatarImageView:(UIImageView*)avatarImageView;
- (void) makeNewInsetIn:(UIScrollView*)scrollView forView:(UIView*)cropView withOffsetX:(CGFloat)offsetX andOffsetY:(CGFloat)offsetY dependingOnAvatarImageView:(UIImageView*)avatarImageView;
- (void) updateDimViewsFrames:(UIView*)leftDim rightDim:(UIView*)rightDim depeningOnCropView:(UIView*)cropView andAvatarImageView:(UIImageView*)avatarImageView;
- (void) rotateAvatarImageView:(UIImageView*)avatarImageView andOriginalPhoto:(UIImage*)original;

@end
