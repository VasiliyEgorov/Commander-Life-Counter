//
//  TextView.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextToolViewController.h"



@interface TextView : UITextView <TextViewProtocol, UITextViewDelegate>

@property (strong, nonatomic) id <TrashViewProtocol> trashViewDelegate;
@property (strong, nonatomic) UIView *trashView;

@end
