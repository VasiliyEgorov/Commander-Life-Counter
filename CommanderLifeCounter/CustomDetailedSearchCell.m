//
//  CustomDetailedSearchCell.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 23.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomDetailedSearchCell.h"
#import "UIColor+Category.h"

@implementation CustomDetailedSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgForCellHighlighted.png"]]];
    [self setSelectedBackgroundView:selectedBackgroundView];
}

- (void)layoutSubviews {
    
    self.cardImage.layer.cornerRadius = 5.f;
    self.cardImage.layer.borderWidth = 1.f;
    self.cardImage.layer.borderColor = [UIColor color_150withAlpha:1].CGColor;
    self.cardImage.layer.masksToBounds = YES;
    self.cardImage.clipsToBounds = YES;
}
@end
