//
//  FiltersData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 12.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FiltersData : NSObject

- (UIImage*) noirFilerWithImage:(UIImage*)originalImage;
- (UIImage*) sepiaFilerWithImage:(UIImage*)originalImage;
- (UIImage*) posterizeFilerWithImage:(UIImage*)originalImage;
- (UIImage*) fadeFilerWithImage:(UIImage*)originalImage;
- (UIImage*) instantFilerWithImage:(UIImage*)originalImage;

@end
