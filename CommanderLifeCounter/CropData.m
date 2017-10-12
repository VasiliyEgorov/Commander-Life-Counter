//
//  EditAvatarAndCropData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 31.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CropData.h"
#import "UIImage+Category.h"

@implementation CropData

- (void) makeNewFrameForCropViewWithScrollViewFrame:(UIScrollView*)scrollView {
    
    CGFloat cropFromY;
    CGFloat cropFromX;
    CGRect newFrame;
    CGFloat offsetY = 0;
    CGFloat offsetX = 0;
    
    if (scrollView.contentSize.width < scrollView.contentSize.height) {
        
        offsetY = (scrollView.frame.size.height  - scrollView.frame.size.width ) / 2;
        
        cropFromY = (scrollView.contentSize.height - scrollView.contentSize.width) / 2;
        cropFromX = 0;
        newFrame = CGRectMake(cropFromX, cropFromY, scrollView.contentSize.width, scrollView.contentSize.width);
        
    } else {
        
        offsetX = (scrollView.frame.size.width - scrollView.contentSize.height) / 2;
        
        cropFromX = (scrollView.contentSize.width - scrollView.contentSize.height) / 2;
        cropFromY = 0;
        newFrame = CGRectMake(cropFromX, cropFromY, scrollView.contentSize.height, scrollView.contentSize.height);
        
    }
    
    [self.delegate calculateOffsetX:offsetX offsetY:offsetY andCropViewFrame:newFrame];
}

- (void) makeStartScrollViewInsetContentSizeAndInsetImageView:(UIImageView*)avatarImageView {
    
    CGSize contentSize;
    UIEdgeInsets contentInset;
    
    UIScrollView *scrollView = (UIScrollView*)avatarImageView.superview;
    
    if (avatarImageView.image.size.width > avatarImageView.image.size.height) {
        
        contentSize = CGSizeMake(avatarImageView.frame.size.width, avatarImageView.frame.size.height);
        CGFloat correction = avatarImageView.frame.size.height / 20;
        
        CGFloat topInset = (scrollView.frame.size.height - avatarImageView.frame.size.height + correction) / 2;
        contentInset = UIEdgeInsetsMake(topInset, 0, 0, 0);
    } else {
        
        contentSize = CGSizeMake(avatarImageView.frame.size.width, avatarImageView.frame.size.height);
        contentInset = UIEdgeInsetsZero;
        
    }
    
    [self.delegate calculateScrollViewContentSize:contentSize andContentInset:contentInset];
}

- (void) makeNewScaleForPhoto:(UIImage*)photo andMakeNewFrameForAvatarImageView:(UIImageView*)avatarImageView {
    CGFloat scrollViewOffset = 44; // leading + trailing constraint
    CGFloat correction = [UIScreen mainScreen].bounds.size.width - scrollViewOffset;
    CGRect rect = CGRectMake(0, 0, correction, [UIScreen mainScreen].bounds.size.height);
    
    UIImage *scaledImage = [UIImage scaleImage:photo toFrame:rect];
    CGRect newFrame = CGRectMake(0, 0, scaledImage.size.width, scaledImage.size.height);
    
 
    [self.delegate scalePhoto:scaledImage andSetFrameForAvatarImageView:newFrame];
}

- (void) makeNewInsetIn:(UIScrollView*)scrollView forView:(UIView*)cropView withOffsetX:(CGFloat)offsetX andOffsetY:(CGFloat)offsetY dependingOnAvatarImageView:(UIImageView*)avatarImageView {
    
    UIEdgeInsets scrollViewInset;
    
    if (avatarImageView.image.size.width > avatarImageView.image.size.height) {
        
        CGFloat zeroRightPositionX = scrollView.contentSize.width - (cropView.frame.origin.x + cropView.frame.size.width + offsetX);
        CGFloat zeroLeftPositionX = cropView.frame.origin.x - offsetX;
        
        if ((zeroRightPositionX <= offsetX) || (zeroLeftPositionX <= offsetX)) {
            
            scrollViewInset = UIEdgeInsetsMake(scrollView.contentInset.top, offsetX, scrollView.contentInset.bottom, offsetX);
        } else {
            
            scrollViewInset = UIEdgeInsetsMake(scrollView.contentInset.top, 0, scrollView.contentInset.bottom, 0);
        }
    }
    else {
        CGFloat zeroUpPositionY = scrollView.contentSize.height - (cropView.frame.origin.y + cropView.frame.size.height + offsetY);
        CGFloat zeroDownPositionY = cropView.frame.origin.y - offsetY;
        
        if ((zeroUpPositionY <= offsetY) || (zeroDownPositionY <= offsetY)) {
            
            scrollViewInset = UIEdgeInsetsMake(offsetY, scrollView.contentInset.left, offsetY, scrollView.contentInset.right);
        } else {
            
            scrollViewInset = UIEdgeInsetsMake(0, scrollView.contentInset.left, 0, scrollView.contentInset.right);
        }
    }
    [self.delegate calculateDynamicallyScrollViewContentInset:scrollViewInset];
}


- (void) updateDimViewsFrames:(UIView*)leftDim rightDim:(UIView*)rightDim depeningOnCropView:(UIView*)cropView andAvatarImageView:(UIImageView*)avatarImageView {
    
    CGRect newFrameForLeftDim;
    CGRect newFrameForRightDim;
    CGRect zeroFrame = CGRectMake(0, 0, 0, 0);
    UIScrollView *superview = (UIScrollView*)cropView.superview;
    
    if (avatarImageView.image.size.width > avatarImageView.image.size.height) {
        
        CGFloat newWidthForLeftDim = -cropView.frame.origin.x;
        CGFloat newWidthForRightDim = superview.contentSize.width - (cropView.frame.origin.x + cropView.frame.size.width);
        newFrameForLeftDim = CGRectMake(cropView.frame.origin.x, cropView.frame.origin.y, newWidthForLeftDim, cropView.frame.size.height);
        newFrameForRightDim = CGRectMake(cropView.frame.origin.x + cropView.frame.size.width, cropView.frame.origin.y, newWidthForRightDim, cropView.frame.size.height);
        
        if (!(newFrameForLeftDim.size.width <= 0)) {
            newFrameForLeftDim = zeroFrame;
            
        }
        if (!(newFrameForRightDim.size.width >= 0)) {
            newFrameForRightDim = zeroFrame;
            
        }
        
    } else {
        
        CGFloat newHeightForLeftDim = -cropView.frame.origin.y;
        CGFloat newHeightForRightDim = superview.contentSize.height - (cropView.frame.origin.y + cropView.frame.size.height);
        newFrameForLeftDim = CGRectMake(cropView.frame.origin.x, cropView.frame.origin.y, cropView.frame.size.width, newHeightForLeftDim);
        newFrameForRightDim = CGRectMake(cropView.frame.origin.x, cropView.frame.origin.y + cropView.frame.size.height, cropView.frame.size.width, newHeightForRightDim);
        
        if (!(newFrameForLeftDim.size.height <= 0)) {
            newFrameForLeftDim = zeroFrame;
            
        }
        if (!(newFrameForRightDim.size.height >= 0)) {
            newFrameForRightDim = zeroFrame;
            
        }
        
    }
    
    [self.delegate calculateLeftDimViewFrame:newFrameForLeftDim andForRightDimView:newFrameForRightDim];
}


- (void) rotateAvatarImageView:(UIImageView*)avatarImageView andOriginalPhoto:(UIImage*)original {
    
    CGRect previousFrame = avatarImageView.frame;
    
    UIImage *previousAvatarImage = avatarImageView.image;
    UIImage *previousOriginal = original;
    CGRect newFrame = CGRectMake(0, 0, previousFrame.size.height, previousFrame.size.width);
    
    UIImage *rotated = [UIImage rotateCCVImagebyMinusHalfPI:previousAvatarImage];
    UIImage *rotatedOriginal = [UIImage rotateCCVImagebyMinusHalfPI:previousOriginal];
    
    [self.delegate rotatedAvatarImageView:rotated newFrameForAvatarImageView:newFrame rotatedOriginal:rotatedOriginal];
    
}

@end
