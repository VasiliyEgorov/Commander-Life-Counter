//
//  AvatarViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 21.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AvatarViewController : UIViewController

@property (strong, nonatomic) UIImage *originalPhoto;
@property (assign, nonatomic) CGRect avatarImageViewFrame;
@property (assign, nonatomic) int counterIndex;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


@end
