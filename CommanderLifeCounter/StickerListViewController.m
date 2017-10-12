//
//  StickerListViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "StickerListViewController.h"
#import "StickersCollectionViewCell.h"

static NSString *const identifier = @"StickersCell";

typedef NS_ENUM (NSUInteger, PicturesSection) {
    MtgSection,
    StickersSection,
    AnimalsSection
};
@interface StickerListViewController ()

@property (strong, nonatomic) NSArray *mtgPicsArray;
@property (strong, nonatomic) NSArray *stickersArray;
@property (strong, nonatomic) NSArray *animalsArray;
@property (assign, nonatomic) CGSize imageSize;
@property (assign, nonatomic) PicturesSection picturesSection;

@end

@implementation StickerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGRect newFrame = CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.width);
    self.view.frame = newFrame;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.collectionView registerClass:[StickersCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    self.mtgPicsArray = @[[UIImage imageNamed:@"mtg_smile3.png"],
                          [UIImage imageNamed:@"mtg_smile4.png"],
                          [UIImage imageNamed:@"mtg_smile7.png"],
                          [UIImage imageNamed:@"mtg_smile8.png"],
                          [UIImage imageNamed:@"mtg_smile9.png"],
                          [UIImage imageNamed:@"mtg_smile10.png"],
                          [UIImage imageNamed:@"mtg_smile12.png"],
                          [UIImage imageNamed:@"mtg_smile13.png"],
                          [UIImage imageNamed:@"mtg_smile2.png"],
                          [UIImage imageNamed:@"mtg_smile1.png"],
                          [UIImage imageNamed:@"mtg_smile14.png"],
                          [UIImage imageNamed:@"mtg_smile5.png"],
                          [UIImage imageNamed:@"mtg_smile6.png"]];
    
    self.stickersArray = @[[UIImage imageNamed:@"smile_1.png"],
                           [UIImage imageNamed:@"smile_2.png"],
                           [UIImage imageNamed:@"smile_3.png"],
                           [UIImage imageNamed:@"smile_4.png"],
                           [UIImage imageNamed:@"smile_5.png"],
                           [UIImage imageNamed:@"smile_6.png"],
                           [UIImage imageNamed:@"smile_7.png"],
                           [UIImage imageNamed:@"smile_8.png"],
                           [UIImage imageNamed:@"smile_10.png"],
                           [UIImage imageNamed:@"smile_11.png"],
                           [UIImage imageNamed:@"smile_12.png"],
                           [UIImage imageNamed:@"smile_13.png"],
                           [UIImage imageNamed:@"smile_14.png"],
                           [UIImage imageNamed:@"smile_15.png"],
                           [UIImage imageNamed:@"smile_16.png"],
                           [UIImage imageNamed:@"smile_17.png"],
                           [UIImage imageNamed:@"smile_18.png"],
                           [UIImage imageNamed:@"smile_19.png"],
                           [UIImage imageNamed:@"smile_20.png"],
                           [UIImage imageNamed:@"smile_21.png"],
                           [UIImage imageNamed:@"smile_22.png"],
                           [UIImage imageNamed:@"smile_23.png"]];
    
    
    self.animalsArray = @[[UIImage imageNamed:@"animals_1.png"],
                          [UIImage imageNamed:@"animals_2.png"],
                          [UIImage imageNamed:@"animals_3.png"],
                          [UIImage imageNamed:@"animals_4.png"],
                          [UIImage imageNamed:@"animals_5.png"],
                          [UIImage imageNamed:@"animals_6.png"],
                          [UIImage imageNamed:@"animals_7.png"],
                          [UIImage imageNamed:@"animals_8.png"],
                          [UIImage imageNamed:@"animals_9.png"],
                          [UIImage imageNamed:@"animals_10.png"],
                          [UIImage imageNamed:@"animals_11.png"],
                          [UIImage imageNamed:@"animals_12.png"],
                          [UIImage imageNamed:@"animals_13.png"],
                          [UIImage imageNamed:@"animals_14.png"],
                          [UIImage imageNamed:@"animals_15.png"],
                          [UIImage imageNamed:@"animals_16.png"]];
    
    
    
    self.mtgStickerButton.selected = YES;
    self.picturesSection = MtgSection;
    
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    switch (self.picturesSection) {
        case MtgSection:
            return [self.mtgPicsArray count];
            break;
        case AnimalsSection:
            return [self.animalsArray count];
            break;
        case StickersSection:
            return [self.stickersArray count];
            break;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StickersCollectionViewCell *stickerCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    switch (self.picturesSection) {
        case MtgSection:
            stickerCell.stickerImageView.image = [self.mtgPicsArray objectAtIndex:indexPath.row];
            break;
        case AnimalsSection:
            stickerCell.stickerImageView.image = [self.animalsArray objectAtIndex:indexPath.row];
            break;
        case StickersSection:
            stickerCell.stickerImageView.image = [self.stickersArray objectAtIndex:indexPath.row];
            break;
    }
    
   
    
    return stickerCell;
    
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    StickersCollectionViewCell *stickerCell = (StickersCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self.delegate sendStricker:stickerCell.stickerImageView.image withSize:self.imageSize];
    
    [self removeAnimation];
}

#pragma mark - Flow delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    CGFloat twentyPersentWidth = self.view.frame.size.width / 5;
    CGFloat height = twentyPersentWidth;
    CGSize imageSize = CGSizeMake(twentyPersentWidth, height);
    self.imageSize = imageSize;
    return imageSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - Animations

- (void) removeAnimation {
    
    CGRect newFrame = CGRectMake(0, self.view.frame.origin.y * 2, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.view.frame = newFrame;
                         
                     } completion:^(BOOL finished) {
                         self.tabBarController.tabBar.hidden = NO;
                         [self.view removeFromSuperview];
                         
                     }];
}

#pragma mark - Actions

- (IBAction)closeButtonAction:(UIButton *)sender {
    
    [self removeAnimation];
}

- (IBAction)mtgStickersButtonAction:(UIButton *)sender {
    
    self.smileButton.selected = NO;
    self.animalsButton.selected = NO;
    self.mtgStickerButton.selected = YES;
    self.picturesSection = MtgSection;
    
    [self.collectionView reloadData];
}


- (IBAction)smileButtonAction:(UIButton *)sender {
    
    self.smileButton.selected = YES;
    self.animalsButton.selected = NO;
    self.mtgStickerButton.selected = NO;
    self.picturesSection = StickersSection;
    
    [self.collectionView reloadData];
}

- (IBAction)animalsButtonAction:(UIButton *)sender {
    
    self.smileButton.selected = NO;
    self.animalsButton.selected = YES;
    self.mtgStickerButton.selected = NO;
    self.picturesSection = AnimalsSection;
    
    [self.collectionView reloadData];
}
@end
