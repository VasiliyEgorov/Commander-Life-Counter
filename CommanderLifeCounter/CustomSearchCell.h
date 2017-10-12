//
//  CustomSearchCell.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrowImage;

@end
