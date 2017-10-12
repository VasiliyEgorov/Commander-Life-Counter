//
//  UIColor+Category.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 30.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Category)

+ (UIColor*) color_20;
+ (UIColor*) color_150withAlpha:(CGFloat)alpha;
+ (UIColor*)color_99withAlpha:(CGFloat)alpha;
+ (UIColor*) color_40;
+ (UIColor*)color_forCropView;
+ (UIColor*)color_DimsCropView:(CGFloat)alpha;
@end
