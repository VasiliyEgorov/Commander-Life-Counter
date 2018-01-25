//
//  CardZoomViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 05.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CardZoomViewController.h"
#import "Constants.h"
#import "CustomRoundedImageView.h"
#import "UIColor+Category.h"

@interface CardZoomViewController ()

@property (strong, nonatomic) UIImageView *cardImageView;
@property (strong, nonatomic) UIView *dimView;
@property (assign, nonatomic) CGFloat cardImageViewScale;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) NSLayoutConstraint *textLabelButtomConstraint;

@end

@implementation CardZoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];

    self.dimView = [[UIView alloc] initWithFrame:self.view.frame];
    self.dimView.backgroundColor = [UIColor color_20];
    self.dimView.alpha = 0.99;
    
    self.cardImageView = [CustomRoundedImageView new];

    [self addTapGestureRecognizer];
    
    self.cardImageView.userInteractionEnabled = YES;
    
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:17];
    self.textLabel.textColor = [UIColor color_150withAlpha:1];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
 
    [self.view addSubview:self.dimView];
    [self.dimView addSubview:self.cardImageView];
    [self addConstraintsToView:self.cardImageView];
    [self.dimView addSubview:self.textLabel];
     [self addConstraintsToView:self.textLabel];
    [self addPinchGestureRecognizerToCardImage:self.cardImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self labelAppearsAnimation];
}


- (void) placeImageToImageView:(UIImage*)image {
    
    self.cardImageView.image = image;
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

- (void) addPinchGestureRecognizerToCardImage:(UIImageView*) cardImageView {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];

    [cardImageView addGestureRecognizer:pinchGesture];
}

- (void) handlePinch:(UIPinchGestureRecognizer*) pinchGesture {

    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.cardImageViewScale = 1.f;
        [self.textLabel removeFromSuperview];
    }
    
    CGFloat newScale = 1.f + pinchGesture.scale - self.cardImageViewScale;
    
    CGAffineTransform currentTransform = self.cardImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    
    self.cardImageView.transform = newTransform;
    
    self.cardImageViewScale = pinchGesture.scale;
}

#pragma mark - Constraints

- (void) addConstraintsToView:(UIView*)view {
 
    if ([view isKindOfClass:[UILabel class]]) {
        
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:25];
        NSLayoutConstraint *equalWidth = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.cardImageView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
        
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.dimView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self.dimView attribute:NSLayoutAttributeBottomMargin multiplier:1 constant:-20];
        
        self.textLabelButtomConstraint = bottom;
        
        [self.dimView addConstraint:height];
        [self.dimView addConstraint:equalWidth];
        [self.dimView addConstraint:bottom];
        [self.dimView addConstraint:centerX];
    }
    
    if ([view isKindOfClass:[UIImageView class]]) {
        
        float h = [UIScreen mainScreen].bounds.size.height;
        CGFloat widthValue = [UIScreen mainScreen].bounds.size.width / 2;
        if (h == IPHONE_X) {
            widthValue = [UIScreen mainScreen].bounds.size.width / 1.6;
        }
        NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:[UIScreen mainScreen].bounds.size.height / 2.3];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:widthValue];
        NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.dimView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.dimView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        
        [self.dimView addConstraint:height];
        [self.dimView addConstraint:width];
        [self.dimView addConstraint:centerX];
        [self.dimView addConstraint:centerY];
    }
   

    view.translatesAutoresizingMaskIntoConstraints = NO;

}

#pragma mark - Animations


- (void) labelAppearsAnimation {
    
    self.textLabel.alpha = 0;
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.textLabel.text = @"Make a Pinch to Zoom";
                         self.textLabel.alpha = 1;
  
                     } completion:^(BOOL finished) {
                         
                         [self labelMovesUpAnimation];
                     }];
}

- (void) labelMovesUpAnimation {
    
    [self.dimView layoutIfNeeded];
    
    self.textLabelButtomConstraint.active = NO;
    
    __block CGRect newFrame = self.textLabel.frame;
    
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         newFrame.origin.y = newFrame.origin.y - 10;
                         self.textLabel.frame = newFrame;
                         
                     } completion:^(BOOL finished) {
                         
                         [self labelMovesBackAnimation];
                     }];

}

- (void) labelMovesBackAnimation {
    
    __block CGRect newFrame = self.textLabel.frame;
    
    [UIView animateWithDuration:1.5
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        
        newFrame.origin.y = newFrame.origin.y + 10;
        self.textLabel.frame = newFrame;
        
    } completion:^(BOOL finished) {
        
        [self labelDisappearsAnimation];
    }];
}

- (void) labelDisappearsAnimation {
    
    self.textLabel.alpha = 1;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         self.textLabel.alpha = 0;
                         
                     } completion:^(BOOL finished) {
                         
                         [self.textLabel removeFromSuperview];
                     }];
}

@end
