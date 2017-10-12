//
//  FlipACoinViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomData.h"


@interface HeadsOrTailsViewController : UIViewController <RandomNumbersProtocol>


@property (strong, nonatomic) RandomData *coinData;

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *tailView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end
