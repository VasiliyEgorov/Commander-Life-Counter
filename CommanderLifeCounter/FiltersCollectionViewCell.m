//
//  FiltersCollectionViewCell.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 12.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "FiltersCollectionViewCell.h"


@implementation FiltersCollectionViewCell

- (void) layoutSubviews {
    [super layoutSubviews];
    self.label.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:self.label.frame.size.height * 2.5/3];
    
}

@end
