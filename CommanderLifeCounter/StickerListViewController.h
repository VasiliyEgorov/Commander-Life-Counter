//
//  StickerListViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StickerListProtocol <NSObject>

- (void) sendStricker:(UIImage*)sticker withSize:(CGSize)stickerSize;

@end

@interface StickerListViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) id <StickerListProtocol> delegate;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

- (IBAction)closeButtonAction:(UIButton *)sender;
- (IBAction)mtgStickersButtonAction:(UIButton *)sender;
- (IBAction)smileButtonAction:(UIButton *)sender;
- (IBAction)animalsButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *smileButton;
@property (weak, nonatomic) IBOutlet UIButton *animalsButton;
@property (weak, nonatomic) IBOutlet UIButton *mtgStickerButton;

@end
