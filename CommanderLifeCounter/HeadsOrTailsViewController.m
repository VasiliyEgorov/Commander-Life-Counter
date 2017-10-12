//
//  FlipACoinViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 08.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "HeadsOrTailsViewController.h"



@interface HeadsOrTailsViewController ()

@property (assign, nonatomic) NSInteger headOrTail;

@end

@implementation HeadsOrTailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.coinData) {
        self.coinData = [[RandomData alloc] init];
        self.coinData.delegate = self;
    }
   
    
    [self addTapGestureRecognizer];
    
    self.headView.alpha = 0.3;
    self.tailView.alpha = 0.3;
    self.textLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self viewAnimations];
}

#pragma mark - RandomNumbersProtocol

- (void)getRandomNumber:(NSInteger)result {
    
    self.headOrTail = result;
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

#pragma mark - Animations

- (void) viewAnimations {
    
    [UIView animateWithDuration:3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                          [self.coinData flipCoin];
                         
                         if (self.headOrTail == 1) {
                             
                             self.tailView.alpha = 1;
                            
                         } else {
                            
                             self.headView.alpha = 1;
                         }
                         
                     } completion:^(BOOL finished) {
                         
                         [self labelAppearsAnimation];
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
