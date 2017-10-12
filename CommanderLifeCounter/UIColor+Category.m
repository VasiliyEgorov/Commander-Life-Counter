//
//  UIColor+Category.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 30.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "UIColor+Category.h"

@implementation UIColor (Category)

+ (UIColor*)color_150withAlpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:alpha];
}

+ (UIColor*) color_20 {
    
    return [UIColor colorWithRed:20/255.0 green:20/255.0 blue:20/255.0 alpha:1];
}


+ (UIColor*) color_40 {
    
    return [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1];
}

+ (UIColor*)color_99withAlpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:alpha];
}

+ (UIColor*)color_forCropView {
    
    return [UIColor colorWithRed:30/255.0 green:144/255.0 blue:255/255.0 alpha:1];
}

+ (UIColor*)color_DimsCropView:(CGFloat)alpha {
    
    return [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:alpha];
}
@end
