//
//  CustomNavController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 12.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomNavController.h"
#import "ManaCounterViewController.h"
#import "UIColor+Category.h"

@interface CustomNavController ()

@end

@implementation CustomNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationBar.translucent = YES;
    self.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor clearColor];
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationBar.tintColor = [UIColor color_150withAlpha:1];
    [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor color_150withAlpha:1] }];
    
    self.toolbar.translucent = YES;
    [self.toolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
    self.toolbar.backgroundColor = [UIColor clearColor];
    self.toolbar.tintColor = [UIColor color_150withAlpha:1];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"backButton.png"]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"backButton.png"]];
    
}



@end
