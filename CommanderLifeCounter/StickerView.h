//
//  StickerImageView.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StickersViewController.h"

@interface StickerView : UIView <UIGestureRecognizerDelegate>

@property (strong, nonatomic) id <TrashViewProtocol> delegate;
@property (strong, nonatomic) UIView *trashView;

@end
