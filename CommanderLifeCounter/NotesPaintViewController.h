//
//  NotesPaintViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 27.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoodleView.h"

@protocol NotesPaintProtocol <NSObject>

- (void) receiveImage:(UIImage*)image;

@end

@interface NotesPaintViewController : UIViewController

@property (weak, nonatomic) id <NotesPaintProtocol> notesDelegate;

@property (weak, nonatomic) IBOutlet DoodleView *doodleView;
@property (weak, nonatomic) IBOutlet UIView *buttonsLayerView;

@end
