//
//  FiltersData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 12.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "FiltersData.h"


@implementation FiltersData



- (UIImage*) noirFilerWithImage:(UIImage*)originalImage {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
    
    CIFilter *noirFilter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
    
    [noirFilter setValue:inputImage forKey:kCIInputImageKey];
    
    CIImage *result = noirFilter.outputImage;
    
    CGImageRef cgImage = [context createCGImage:result fromRect:result.extent];
    
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage scale:originalImage.scale orientation:originalImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
    return filteredImage;
}

- (UIImage*) sepiaFilerWithImage:(UIImage*)originalImage {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
    
    CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    
    [sepiaFilter setValue:inputImage forKey:kCIInputImageKey];
    
    CIImage *result = sepiaFilter.outputImage;
    
    CGImageRef cgImage = [context createCGImage:result fromRect:result.extent];
    
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage scale:originalImage.scale orientation:originalImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
    return filteredImage;
}

- (UIImage*) posterizeFilerWithImage:(UIImage*)originalImage {
    
    NSDictionary *options = @{kCIAttributeTypeScalar : [NSNumber numberWithFloat:3]};
    
    CIContext *context = [CIContext contextWithOptions:options];
    
    CIImage *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
    
    CIFilter *posterizeFilter = [CIFilter filterWithName:@"CIColorPosterize"];
    
    [posterizeFilter setValue:inputImage forKey:kCIInputImageKey];
    
    CIImage *result = posterizeFilter.outputImage;
    
    CGImageRef cgImage = [context createCGImage:result fromRect:result.extent];
    
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage scale:originalImage.scale orientation:originalImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
    return filteredImage;
}

- (UIImage*) fadeFilerWithImage:(UIImage*)originalImage {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
    
    CIFilter *fadeFilter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
    
    [fadeFilter setValue:inputImage forKey:kCIInputImageKey];
    
    CIImage *result = fadeFilter.outputImage;
    
    CGImageRef cgImage = [context createCGImage:result fromRect:result.extent];
    
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage scale:originalImage.scale orientation:originalImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
    return filteredImage;
}

- (UIImage*) instantFilerWithImage:(UIImage*)originalImage {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CIImage *inputImage = [CIImage imageWithCGImage:originalImage.CGImage];
    
    CIFilter *instantFilter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
    
    [instantFilter setValue:inputImage forKey:kCIInputImageKey];
    
    CIImage *result = instantFilter.outputImage;

    CGImageRef cgImage = [context createCGImage:result fromRect:result.extent];
    
    UIImage *filteredImage = [UIImage imageWithCGImage:cgImage scale:originalImage.scale orientation:originalImage.imageOrientation];
    
    CGImageRelease(cgImage);
    
    return filteredImage;
}


@end
