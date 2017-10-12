//
//  DoodleProtocols.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 27.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ControllerToDoodleProtocol <NSObject>

- (void) disableButtons;
- (void) enableButtons;

@end

@protocol DoodleToControllerProtocol <NSObject>

- (void) undoButton;
- (void) resetButton;
- (NSArray*)receivePathsArray;

@end

@protocol ColorPaletteForDoodleProtocol <NSObject>

- (UIColor*) receiveColor;
- (void) hideColorPalette;
- (void) showColorPalette;
- (CGFloat) receiveLineToolWidth;

@end

@protocol TrashViewProtocol <NSObject>

- (void) hideTrashView;
- (void) showTrashView;
- (void) changeTrashViewColorToReadyToDelete;
- (void) changeTrashViewColorToFirstState;
- (void) animateTrashOpening;
- (void) animateTrashClosing;
- (void) animateDelete:(UIView*)objectToDelete;
- (void) transformObjectToReadyToDelete:(UIView*)view;
- (void) transformObjectToPreviousCondition:(UIView*)view;

@end

@protocol TextViewProtocol <NSObject>

- (void) receiveTextColor:(UIColor*)color;


@end
