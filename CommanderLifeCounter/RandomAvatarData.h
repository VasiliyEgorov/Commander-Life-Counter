//
//  RandomAvatarData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 24.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandomAvatarData : NSObject

- (UIImage*) selectAvatarForName:(NSString*)name scaleImageTo:(CGRect)frame;

@end
