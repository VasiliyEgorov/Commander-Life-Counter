//
//  RollADieViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 14.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "RollADieViewController.h"

@interface RollADieViewController ()

@property (assign, nonatomic) CGFloat randomNumber;
@property (assign, nonatomic) CGFloat eachAnimationDuration;
@property (assign, nonatomic) NSInteger i;
@end

@implementation RollADieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rollData = [[RandomData alloc] init];
    self.rollData.delegate = self;
    for (UIView *view in self.imageViewArray) {
        view.alpha = 0.3;
    }
    [self addTapGestureRecognizer];
    
    self.i = 0;
    self.textLabel.text = @"";
    [self.rollData rollADie];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self animateViewWithduration:self.eachAnimationDuration];
    
}

#pragma mark - TapsGesture

- (void) addTapGestureRecognizer {
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void) tapGestureAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RandomNumbersProtocol

- (void) getRandomNumber:(NSInteger) result {
    
    self.randomNumber = result;
    
    self.eachAnimationDuration = 3 / self.randomNumber;
    
}

#pragma mark - Animations

- (void) animateViewWithduration:(CGFloat)duration {
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         if (self.i < self.randomNumber) {
                             UIView *view = [self.imageViewArray objectAtIndex:self.i++];
                             view.alpha = 1;
                         }
                     } completion:^(BOOL finished) {
                         if (self.i < self.randomNumber) {
                             [self animateViewWithduration:self.eachAnimationDuration];
                         }
                         
                           else {
                              [self labelAppearsAnimation];
                          }
                     }];

}

- (void) labelMovesUpAndBackAnimation {
    
    __block CGRect newFrame = self.textLabel.frame;
    
    [UIView animateWithDuration:1.5 delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         
                         newFrame.origin.y = newFrame.origin.y - 10.f;

                         self.textLabel.frame = newFrame;
                      
                     } completion:nil];

}

- (void) labelAppearsAnimation {
    
    self.textLabel.alpha = 0;
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.textLabel.text = @"Tap anywhere to close";
                         self.textLabel.alpha = 1;
                         
                     } completion:^(BOOL finished) {
                         
                         [self labelMovesUpAndBackAnimation];
                     }];
}

@end
