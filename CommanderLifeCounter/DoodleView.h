//
//  DoodleView.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 04.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorPaletteForDoodle.h"
#import "AvatarEditProtocols.h"


@interface DoodleView : UIView <DoodleToControllerProtocol>

@property (strong, nonatomic) id <ColorPaletteForDoodleProtocol> delegate;
@property (strong, nonatomic) id <ControllerToDoodleProtocol> controllerToDoodleDelegate;



@end
