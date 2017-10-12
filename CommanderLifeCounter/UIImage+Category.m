//
//  UIImage+Category.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 29.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "UIImage+Category.h"



@implementation UIImage (Category)

+ (id)resizeImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    if (image.size.width < newSize.width && image.size.height < newSize.height) {
        return image;
    }
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}




+ (id) scaleImage:(UIImage*)image toFrame:(CGRect)rect  {
    
    CGFloat newScaleForFrame;
    CGFloat newPhotoSizeWidth = rect.size.width * 2;
    CGFloat newPhotoSizeHeight = newPhotoSizeWidth * image.size.height / image.size.width;
    UIImage *resizedImage = [UIImage resizeImage:image scaledToSize:CGSizeMake(newPhotoSizeWidth, newPhotoSizeHeight)];
    
    if (image.size.width < image.size.height) {
        
        CGFloat currentPhotoWidth = resizedImage.size.width;
        newScaleForFrame = currentPhotoWidth / rect.size.width;
    }
    else {
        
        CGFloat currentPhotoHeight = resizedImage.size.height;
        newScaleForFrame = currentPhotoHeight / rect.size.width;
    }
    
    UIImage *scaledImage = [UIImage imageWithCGImage:resizedImage.CGImage scale:newScaleForFrame orientation:resizedImage.imageOrientation];

    return scaledImage;
    
}



+ (id) convertImageToData:(UIImage*)image {
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    return imageData;
    
}

+ (id) cropImage:(UIImage*)image toRect:(CGRect)rect {
    
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    
    CGAffineTransform rectTransform;
    switch (image.imageOrientation) {
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -image.size.width, -image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    rectTransform = CGAffineTransformScale(rectTransform, image.scale, image.scale);
    
    CGFloat cropFromY;
    CGFloat cropFromX;
    CGRect rectToCrop;
    
    if (image.size.width < image.size.height) {
        cropFromY = (image.size.height - rect.size.height) / 2;
        cropFromX = 0;
        rectToCrop = CGRectMake(cropFromX, cropFromY, rect.size.width, rect.size.height);
    } else {
        cropFromX = (image.size.width - rect.size.height) / 2;
        cropFromY = 0;
        rectToCrop = CGRectMake(cropFromX, cropFromY, rect.size.width, rect.size.height);
        
    }

    CGRect transformedCropSquare = CGRectApplyAffineTransform(rectToCrop, rectTransform);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, transformedCropSquare);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    
    return croppedImage;
}

+ (id) cropImage:(UIImage*)image byCropViewFrames:(CGRect)rect {
    
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    
    CGAffineTransform rectTransform;
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -image.size.height);
            break;
        case UIImageOrientationRight:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -image.size.width, 0);
            break;
        case UIImageOrientationDown:
            rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -image.size.width, -image.size.height);
            break;
        default:
            rectTransform = CGAffineTransformIdentity;
    };
    
    rectTransform = CGAffineTransformScale(rectTransform, image.scale, image.scale);
    
    CGFloat cropFromY;
    CGFloat cropFromX;
    CGRect rectToCrop;
    
   if (image.size.width < image.size.height) {
        cropFromY = rect.origin.y;
        cropFromX = 0;
        rectToCrop = CGRectMake(cropFromX, cropFromY, rect.size.width, rect.size.height);
} else {
    cropFromX = rect.origin.x;
        cropFromY = 0;
       rectToCrop = CGRectMake(cropFromX, cropFromY, rect.size.width, rect.size.height);
    
    }
    
    CGRect transformedCropSquare = CGRectApplyAffineTransform(rectToCrop, rectTransform);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, transformedCropSquare);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);

    return croppedImage;
}

+ (id) mergeViewAndItsLayer:(UIView*)view {
    
    CGSize imgSize = CGSizeMake(view.bounds.size.width, view.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(imgSize, NO , 0.0f);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}

+ (id) rotateCCVImagebyMinusHalfPI:(UIImage*)image {
    
    CGFloat (^rad)(CGFloat) = ^CGFloat(CGFloat deg) {
        return deg / 180.0f * (CGFloat) M_PI;
    };
    
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0, image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(rad(-90));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
   
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    
    CGContextRotateCTM(bitmap, rad(-90));
    
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *rotated = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rotated;
}





+ (id) lanczosScaleFilter:(UIImage*)image scaleTo:(CGFloat)scale {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *lanczos = [CIFilter filterWithName:@"CILanczosScaleTransform"];
    
    [lanczos setValue:inputImage forKey:kCIInputImageKey];
    [lanczos setValue:@(scale) forKey:kCIInputScaleKey];
    CIImage *result = lanczos.outputImage;
    
    CGImageRef cgImage = [context createCGImage:result fromRect:result.extent];
    
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage];
    
    return filteredImage;
}


@end
