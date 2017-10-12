//
//  colorPaletteForTextView.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextView.h"

@interface ColorPaletteForTextView : UIImageView

@property (strong, nonatomic) id <TextViewProtocol> delegate;

@end
