//
//  CardDetailedSearchViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 23.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchManager.h"

@interface CardDetailedSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *resultsArray;
@property (strong, nonatomic) UITabBarController *tabBar;
@property (strong, nonatomic) SearchManager *searchManager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)jumpToManaCounters:(UIBarButtonItem *)sender;
- (IBAction)jumpToPlayerCounters:(UIBarButtonItem *)sender;
- (IBAction)jumpToNotes:(UIBarButtonItem *)sender;

@end
