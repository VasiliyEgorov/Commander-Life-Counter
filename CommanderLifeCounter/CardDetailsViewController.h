//
//  CardDetailsViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultsData.h"

@interface CardDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rarityLabel;
@property (weak, nonatomic) IBOutlet UILabel *legalityLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerAndToughnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *setNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *manaCostAndColorsLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewtopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topTopStackViewContraint;

@property (strong, nonatomic) SearchResultsData *card;

@end
