//
//  CustomTabSwitchAnimation.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 06.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface CustomTabSwitchAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (assign, nonatomic) NSInteger fromIndex;
@property (assign, nonatomic) NSInteger toIndex;

- (CustomTabSwitchAnimation*) getFromIndex:(NSInteger)fromIndex andToIndex:(NSInteger)toIndex;

@end
