//
//  CustomCell.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.04.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNoteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellDetailedTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholder;

@end
