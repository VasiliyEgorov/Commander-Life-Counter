//
//  CustomRefreshButton.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 23.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomRefreshButton.h"

@implementation CustomRefreshButton

- (void)drawRect:(CGRect)rect {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(1.5, 1.5);
    self.layer.masksToBounds = NO;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    
    [NSOperationQueue.mainQueue addOperationWithBlock:^{ self.highlighted = YES; }];
}


- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self performSelector:@selector(setDefault) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self performSelector:@selector(setDefault) withObject:nil afterDelay:0.1];
}


- (void)setDefault
{
    [NSOperationQueue.mainQueue addOperationWithBlock:^{ self.highlighted = NO; }];
}


@end
