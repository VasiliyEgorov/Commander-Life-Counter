//
//  AwaitingViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 25.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "AwaitingViewController.h"
#import "CustomRefreshButton.h"

@interface AwaitingViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) UIView *dimView;
@property (strong, nonatomic) UIView *indicatorSubview;
@end

@implementation AwaitingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.alpha = 0.4;
    self.dimView = [[UIView alloc] initWithFrame:self.view.frame];
    self.dimView.backgroundColor = [UIColor blackColor];
    self.dimView.alpha = 0.8;
    
    [self.view addSubview:self.dimView];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    [self.dimView addSubview:self.indicator];
    [self addConstraintsToView:self.indicator];
    
    [self addTapGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.indicator setHidden:NO];
    [self.indicator startAnimating];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self.indicator setHidden:YES];
    [self.indicator stopAnimating];
}

#pragma mark - Tap gesture

- (void) addTapGestureRecognizer {
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void) tapGestureAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Constraints

- (void) addConstraintsToView:(UIView*)view {
    
    CGFloat multiplierHeight;
    CGFloat multiplierWidth;
    
    if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
        multiplierHeight = 0.2;
        multiplierWidth = 0.4;
    } else {
        multiplierHeight = 0.05;
        multiplierWidth = 0.07;
    }
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.dimView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.dimView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.dimView attribute:NSLayoutAttributeHeight multiplier:multiplierHeight constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.dimView attribute:NSLayoutAttributeWidth multiplier:multiplierWidth constant:0];
    
    [self.dimView addConstraint:centerX];
    [self.dimView addConstraint:centerY];
    [self.dimView addConstraint:height];
    [self.dimView addConstraint:width];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}


@end
