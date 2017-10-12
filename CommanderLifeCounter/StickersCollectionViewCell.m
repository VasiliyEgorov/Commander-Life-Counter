//
//  CollectionViewCell.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "StickersCollectionViewCell.h"

@implementation StickersCollectionViewCell

- (UIImageView*) stickerImageView {
    
    if (!_stickerImageView) {
        
        _stickerImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_stickerImageView];
    }
    
    return _stickerImageView;
}

- (void) prepareForReuse {
    [super prepareForReuse];
    
    [self.stickerImageView removeFromSuperview];
    self.stickerImageView = nil;
}

@end
