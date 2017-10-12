//
//  RollADieViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 14.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RandomData.h"

@interface RollADieViewController : UIViewController <RandomNumbersProtocol>

@property (strong, nonatomic) RandomData *rollData;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *imageViewArray;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@end
