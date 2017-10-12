//
//  CustomMenuCell.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 13.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomMenuCell.h"
#import "UIColor+Category.h"

@implementation CustomMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor color_20]];
    [self setSelectedBackgroundView:selectedBackgroundView];
}

@end
