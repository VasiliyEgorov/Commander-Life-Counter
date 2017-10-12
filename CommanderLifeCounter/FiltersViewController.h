//
//  FiltersViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 12.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditAvatarViewController.h"

extern NSString* const FilterToCropNotification;
extern NSString* const FilterToStickerNotification;
extern NSString* const FilterToTextNotification;
extern NSString* const FilterToDoodleNotification;

extern NSString* const FilterImageUserInfoKey;
extern NSString* const FilterSubviewsUserInfoKey;
extern NSString* const FilterEditedFullSizePhotoUserInfoKey;

@interface FiltersViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (assign, nonatomic) SelectedController selectedController;
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIView *collectionLayerView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (void)removeNotifications;

@end
