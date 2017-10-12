//
//  CustomUITabBarController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 06.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CustomUITabBarController.h"
#import "CustomTabSwitchAnimation.h"

@interface CustomUITabBarController ()

@end

@implementation CustomUITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    for (UINavigationController *navController in self.viewControllers) {
        
        UIViewController *firstController = navController.topViewController;
        [firstController.view setNeedsLayout];
        [firstController.view layoutIfNeeded];
        [firstController.view updateConstraintsIfNeeded];
    }
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC {
    

    
        NSArray *tabViewControllers = tabBarController.viewControllers;
        NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
        NSUInteger toIndex = [tabViewControllers indexOfObject:toVC];
        
    
        
    if ((fromIndex == 0 && toIndex == 3) || (fromIndex == 3 && toIndex == 0)) {
        
        return nil;
    }
    
    else if (fromIndex == 0 && toIndex == 1) {
        
        return [[[CustomTabSwitchAnimation alloc] init] getFromIndex:fromIndex + 1 andToIndex:toIndex - 1];
    }
    else if (fromIndex == 1 && toIndex == 0) {
        
        return [[[CustomTabSwitchAnimation alloc] init] getFromIndex:fromIndex - 1 andToIndex:toIndex + 1];
    }
    else if (fromIndex == 3 && toIndex == 2) {
        
        return [[[CustomTabSwitchAnimation alloc] init] getFromIndex:fromIndex - 1 andToIndex:toIndex + 1];
    }
    else {
        
        return [[[CustomTabSwitchAnimation alloc] init] getFromIndex:fromIndex andToIndex:toIndex];
    }
    
}

@end
