//
//  CardSearchViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CardSearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)backButton:(UIBarButtonItem *)sender;
- (IBAction)jumpToManaCounters:(UIBarButtonItem *)sender;
- (IBAction)jumpToPlayerCounters:(UIBarButtonItem *)sender;
- (IBAction)jumpToNotes:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopContraint;




@end
