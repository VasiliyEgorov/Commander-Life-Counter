//
//  CardDetailsViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CardDetailsViewController.h"
#import "Constants.h"
#import "CustomRefreshButton.h"
#import "CustomNoImageView.h"
#import "UIImageView+AFNetworking.h"
#import "CardZoomViewController.h"

@interface CardDetailsViewController ()


@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) CustomRefreshButton *refreshButton;
@property (strong, nonatomic) CardZoomViewController *cardZoomController;

@end

@implementation CardDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initRightSwipes];
    [self changeConstraints];
    self.navigationController.toolbarHidden = YES;
    self.cardImageView.userInteractionEnabled = YES;
    
    self.nameLabel.text = self.card.cardName;
    self.manaCostAndColorsLabel.text = [NSString stringWithFormat:@"%ld %@", (long)self.card.cmc, self.card.cardColorIdentity];
    self.setNameLabel.text = self.card.setName;
    self.rarityLabel.text = self.card.rarity;
    self.textLabel.text = self.card.text;   
    self.legalityLabel.text = [NSString stringWithFormat:@"Legal in: %@", self.card.legalitiesString];
    self.typeLabel.text = self.card.type;
    self.powerAndToughnessLabel.text = [NSString stringWithFormat:@"%@ / %@", self.card.cardPower, self.card.cardToughness];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
 
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [self tryToGetCardImage];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



#pragma mark - Swipes

- (void) initRightSwipes {
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    
}


- (void) handleLeftSwipe:(UISwipeGestureRecognizer*) recognizer {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Get Card Image

- (void) tryToGetCardImage {
    
    if (self.card.urlString != nil) {
        
        [self.cardImageView addSubview:self.indicator];
        [self addConstraintsToNoImageSignView:self.indicator];
        [self.indicator setHidden:NO];
        [self.indicator startAnimating];
        
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.card.urlString]];
        [self.cardImageView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
            
                                               [self.indicator stopAnimating];
                                               [self.indicator setHidden:YES];
            
                                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                               
                                               [self animatePlacingImage:self.cardImageView to:image];
                                               
                                               [self addCardZoomController:self.cardImageView];
                                               
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self.indicator stopAnimating];
            [self.indicator setHidden:YES];
            self.cardImageView.image = [UIImage imageNamed:@"cardBlur.png"];
            [self initRefreshButton];
        }];
    }
    else {
        
        [self initNoImageSignView];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
    
}


#pragma mark - Buttons

- (void) initNoImageSignView {
    
    CustomNoImageView *noSignImageView = [[CustomNoImageView alloc] initWithImage:[UIImage imageNamed:@"noImageSign.png"]];
    
    [self.cardImageView addSubview:noSignImageView];
    [self addConstraintsToNoImageSignView:noSignImageView];
}

- (void) initRefreshButton {
    
    self.refreshButton = [CustomRefreshButton buttonWithType:UIButtonTypeSystem];
    self.refreshButton.frame = CGRectMake(0, 0, 50, 50);
    [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"refreshForCard.png"] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(refreshButtonAction) forControlEvents:UIControlEventTouchUpInside];
   
    [self.cardImageView addSubview:self.refreshButton];
    [self addConstraintsToNoImageSignView:self.refreshButton];
}

- (void) refreshButtonAction {
    
    [self.refreshButton removeFromSuperview];
    [self tryToGetCardImage];
}


#pragma mark - CardZoom controller

- (void) addCardZoomController:(UIImageView*)cardImageView {
    
    self.cardZoomController = [[CardZoomViewController alloc] init];
    [self.cardZoomController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.cardZoomController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    [self addTapGestureRecognizerToCardImage:cardImageView];
}

#pragma mark - Add Tap to CardZoom controller

- (void) addTapGestureRecognizerToCardImage:(UIImageView*)cardImageView {
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    tapRecognizer.numberOfTapsRequired = 1;
    [cardImageView addGestureRecognizer:tapRecognizer];
}

- (void) tapGestureAction {
    
    [self presentViewController:self.cardZoomController animated:YES completion:nil];
    [self.cardZoomController placeImageToImageView:self.cardImageView.image];
}

#pragma mark - Animations

- (void) animatePlacingImage:(UIImageView*)cardImageView to:(UIImage*)downloadedImage {
    
    [UIView transitionWithView:cardImageView
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        
                        cardImageView.image = downloadedImage;
                        
                    } completion:nil];
}

#pragma mark - Constraints

- (void) addConstraintsToNoImageSignView:(UIView*)view {
    
    CGFloat multiplierHeight;
    CGFloat multiplierWidth;
    
    if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
        multiplierHeight = 0.2;
        multiplierWidth = 0.4;
    } else {
        multiplierHeight = 0.2;
        multiplierWidth = 0.3;
    }
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.cardImageView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.cardImageView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:multiplierHeight constant:50];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:multiplierWidth constant:50];
    
    [self.cardImageView addConstraint:centerX];
    [self.cardImageView addConstraint:centerY];
    [self.cardImageView addConstraint:height];
    [self.cardImageView addConstraint:width];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
     
}

- (void)changeConstraints {
    
    float h = [UIScreen mainScreen].bounds.size.height;
    
    if (h == IPHONE_X_XS || h == IPHONE_XSMAX_XR){
        self.navigationItem.title = @"Card details";
        
        self.topTopStackViewContraint.constant = 105;
        
        self.imageViewLeadingConstraint.constant = 95;
        self.imageViewTrailingConstraint.constant = 95;
        self.imageViewTopConstraint.constant = 80;
        self.bottomViewBottomConstraint.constant = 50;
        self.topViewtopConstraint.constant = 45;
        
    }
    if (h == IPHONE_6_7_PLUS){
        self.navigationItem.title = @"Card details";
        
        self.topTopStackViewContraint.constant = 80;

        self.imageViewLeadingConstraint.constant = 110;
        self.imageViewTrailingConstraint.constant = 110;
        self.imageViewTopConstraint.constant = 80;
        self.bottomViewBottomConstraint.constant = 50;
        self.topViewtopConstraint.constant = 45;
        
    }
    if (h == IPHONE_6_7){
        
        self.imageViewLeadingConstraint.constant = 90;
        self.imageViewTrailingConstraint.constant = 90;
        self.imageViewTopConstraint.constant = 35;
        self.bottomViewBottomConstraint.constant = 45;
        self.topViewtopConstraint.constant = 45;
        
    }
    if (h == IPHONE_5){
        
        self.imageViewLeadingConstraint.constant = 75;
        self.imageViewTrailingConstraint.constant = 75;
        self.imageViewTopConstraint.constant = 21;
        self.topViewtopConstraint.constant = 35;
        self.bottomViewBottomConstraint.constant = 35;
    }
    
    [self.view updateConstraintsIfNeeded];
}

- (void) dealloc {
    [self.cardImageView cancelImageDownloadTask];
}

@end
