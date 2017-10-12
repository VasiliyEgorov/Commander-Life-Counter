//
//  CustomDetailedSearchCell.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 23.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDetailedSearchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cardImage;
@property (weak, nonatomic) IBOutlet UILabel *cardNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardRarityLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardLegalitiesLabel;

@end
