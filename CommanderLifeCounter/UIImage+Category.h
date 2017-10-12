//
//  UIImage+Category.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 29.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

+ (id)resizeImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (id)convertImageToData:(UIImage*)image;
+ (id) cropImage:(UIImage*)image toRect:(CGRect)rect;
+ (id) scaleImage:(UIImage*)image toFrame:(CGRect)rect;
+ (id) cropImage:(UIImage*)image byCropViewFrames:(CGRect)rect;
+ (id) mergeViewAndItsLayer:(UIView*)view;
+ (id) rotateCCVImagebyMinusHalfPI:(UIImage*)image;
+ (id) lanczosScaleFilter:(UIImage*)image scaleTo:(CGFloat)scale;

@end
