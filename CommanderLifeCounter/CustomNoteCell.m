//
//  CustomCell.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.04.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomNoteCell.h"



@implementation CustomNoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgForCellHighlighted.png"]]];
    [self setSelectedBackgroundView:selectedBackgroundView];

}


- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:YES];
    
    if (editing) {
        [self overrideEditControlImage];
    }
}




- (void)willTransitionToState:(UITableViewCellStateMask)state {
    
    [super willTransitionToState:state];
   
    
    
    [self overrideDeleteConfirmationViewAndButton];
    
}

- (void) overrideEditControlImage {
    UIButton *customEditBtn;
    for (UIView * view in self.subviews) {
        if ([NSStringFromClass([view class]) rangeOfString: @"UITableViewCellEditControl"].location != NSNotFound) {
            for (UIView * subview in view.subviews) {
                if ([subview isKindOfClass: [UIImageView class]]) {
                    [subview removeFromSuperview];
                    
                    if (customEditBtn == nil) {
                        customEditBtn = [[UIButton alloc] initWithFrame:CGRectMake(-32, 0, 37, 53)];
                        customEditBtn.adjustsImageWhenHighlighted = NO;
                        [customEditBtn setImage:[UIImage imageNamed:@"deleteForCell.png"] forState:UIControlStateNormal];
                        [self.contentView addSubview:customEditBtn];
                    }
                }
            }
        }
        
    }
}



- (UIView*)findUITableViewCellActionButton:(UIView*)view {
 
        for(UIView *subview in view.subviews) {
            
            if([NSStringFromClass([subview class]) rangeOfString:@"UITableViewCellActionButton"].location != NSNotFound) {
                
                return subview;
            } else {
            UIView *result = [self findUITableViewCellActionButton:subview];
            if(result)
                return result;
            }
        }
 
    return nil;
    
}


- (UIView*)findUITableViewCellDeleteConfirmationView:(UIView*)view {
    
    for(UIView *subview in view.subviews) {
        
        if([NSStringFromClass([subview class]) rangeOfString:@"UITableViewCellDeleteConfirmationView"].location != NSNotFound) {
            return subview;
        } else {
        
        UIView *result = [self findUITableViewCellDeleteConfirmationView:subview];
        if(result)
            return result;
        }
    }
    
    return nil;
    
}



-(void)overrideDeleteConfirmationViewAndButton {

    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *confirmationButton = [self findUITableViewCellActionButton:self];
        UIView *confirmationDeleteView = [self findUITableViewCellDeleteConfirmationView:self];
      
        if(confirmationButton)
        {
            confirmationButton.frame = CGRectMake(0, 2, 80, 51);
            confirmationButton.layer.cornerRadius = 8;
            confirmationButton.layer.masksToBounds = YES;
            confirmationButton.backgroundColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
            
        }
        if (confirmationDeleteView) {
            confirmationDeleteView.backgroundColor = [UIColor clearColor];
        }
      
    });
}

@end
