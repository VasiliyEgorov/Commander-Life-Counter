//
//  RandomAvatarData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 24.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "RandomAvatarData.h"
#import "Constants.h"
#import "UIImage+Category.h"

@interface RandomAvatarData ()

@property (strong, nonatomic) UILabel *nameLabel;
@property (assign, nonatomic, getter=isDarkColor) BOOL darkColor;

@end

@implementation RandomAvatarData

- (UIImage*) selectAvatarForName:(NSString*)name scaleImageTo:(CGRect)frame {
    
    if ([name isEqualToString:EMPTY] || [name isEqualToString:SPACE]) {
        return nil;
    }
   
    NSMutableString *result = [NSMutableString string];
    
    NSRange firstLetterRange = NSMakeRange(0, 1);
    
    NSString *firstLetterString = [[name substringWithRange:firstLetterRange] capitalizedString];

    [result appendString:firstLetterString];
    
    NSRange searchForSpaces = [name rangeOfString:SPACE];
    NSRange secondLetterRange = NSMakeRange(searchForSpaces.location + 1, 1);
    NSUInteger nameLength = [name length];
    
    if (searchForSpaces.location != NSNotFound ) {
        
        if (secondLetterRange.location < nameLength) {
            NSString *secondLetterString = [[name substringWithRange:secondLetterRange] capitalizedString];
            [result appendString:secondLetterString];
        }
       
    }
    UIImage *randomAvatar = [self chooseRandomAvatar];
    UIImage *scaled = [UIImage scaleImage:randomAvatar toFrame:frame];
    
    return [self makeLabelBasedOnFrame:frame forName:result andMergeWithImage:scaled];
}

- (UIImage*) chooseRandomAvatar {
    
    UIImage *silver = [UIImage imageNamed:@"silver.png"];
    UIImage *white = [UIImage imageNamed:@"white.png"];
    
    NSArray *avatarsArray = @[[UIImage imageNamed:@"blue.png"],
                             [UIImage imageNamed:@"blueCyan.png"],
                             [UIImage imageNamed:@"gray.png"],
                             [UIImage imageNamed:@"greenCyan.png"],
                             [UIImage imageNamed:@"lightBlue.png"],
                             silver,
                             white];
    int count = (int)[avatarsArray count];
    
    UIImage *result = [avatarsArray objectAtIndex:arc4random_uniform(count)];
    
    if ([result isEqual:silver] || [result isEqual:white]) {
        self.darkColor = YES;
    }
    return result;
}

- (UIImage*) makeLabelBasedOnFrame:(CGRect)frame forName:(NSString*)name andMergeWithImage:(UIImage*)avatar  {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:label.frame.size.height / 2];
    label.textAlignment = NSTextAlignmentCenter;
    if (self.isDarkColor) {
        label.textColor = [UIColor colorWithRed:78/255.0 green:46/255.0 blue:40/255.0 alpha:1];
    }
    else {
        label.textColor = [UIColor whiteColor];
    }
    label.text = name;
    
    [label sizeToFit];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:avatar];
    
    [imageView addSubview:label];
    
    CGPoint newCenter = CGPointMake(CGRectGetMidX(imageView.bounds), CGRectGetMidY(imageView.bounds));
    
    label.center = newCenter;
    
    UIImage *merdgedImage = [UIImage mergeViewAndItsLayer:imageView];
    
    return merdgedImage;
}


@end
