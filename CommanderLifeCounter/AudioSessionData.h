//
//  AudioSessionData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 27.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AVFoundation;

@protocol VolumeButtonsProtocol <NSObject>

- (void) volumeButtonPressed;

@end

@interface AudioSessionData : NSObject

@property (weak, nonatomic) id <VolumeButtonsProtocol> delegate;

@end
