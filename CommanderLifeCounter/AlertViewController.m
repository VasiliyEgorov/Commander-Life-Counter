//
//  AlertViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 04.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "AlertViewController.h"
#import "UIColor+Category.h"

@interface AlertViewController ()

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIView *bgView;
@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.bgView.backgroundColor = [UIColor color_20];
    self.bgView.layer.cornerRadius = 15.f;
    self.bgView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgView.layer.shadowRadius = 2;
    self.bgView.layer.shadowOpacity = 1;
    self.bgView.layer.shadowOffset = CGSizeMake(3, 3);

    self.bgView.center = self.view.center;
    [self.view addSubview:self.bgView];
   
    self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 75, 200, 40)];
    self.textLabel.textColor = [UIColor color_150withAlpha:1];
    self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:40];
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.minimumScaleFactor = 0.5;
    [self.bgView addSubview:self.textLabel];

    [self addTapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void) addTapGestureRecognizer {
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void) tapGestureAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) placeTextIfButtonPressed:(BOOL)isPressed {
    
    if (isPressed) {
        self.textLabel.text = @"Screen auto lock OFF";
    } else {
        self.textLabel.text = @"Screen auto lock ON";
    }
    
    dispatch_time_t dismissTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    
    dispatch_after(dismissTime, dispatch_get_main_queue(), ^(void){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


@end
