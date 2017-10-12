//
//  SlideMenuViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 09.04.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "SWRevealViewController.h"
#import "CustomMenuCell.h"
#import "CardSearchViewController.h"
#import "UIColor+Category.h"

@interface SlideMenuViewController () 

@property (strong, nonatomic) NSArray *menuArray;

@end

@implementation SlideMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

    self.menuArray = @[@"Card search", @"Roll a die", @"Heads or tails", @"Reset all counters"];
    
    [self tableViewSettings];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableViewSettings {
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor darkGrayColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.navigationController.toolbarHidden = YES;
     [self.navigationItem setTitle:@"Menu"];
}

- (void) revealToggle:(BOOL) animated {
    animated = YES;
    [self.revealViewController revealToggleAnimated:animated];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.menuArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   static NSString *identifier = @"MenuCell";
    
    CustomMenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
       
   menuCell.menuTextLabel.text = [self.menuArray objectAtIndex:indexPath.row];
    
    menuCell.backgroundColor = [UIColor clearColor];
    
    return menuCell;
}

#pragma mark - TableViewDelegate

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomMenuCell *cell = (CustomMenuCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor color_40];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomMenuCell *cell = (CustomMenuCell*)[tableView cellForRowAtIndexPath:indexPath];
    UIColor *color = [UIColor clearColor];
    cell.backgroundColor = color;
    cell.contentView.backgroundColor = color;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        
        case search:
            [self getToSearchController];
            break;
        case flipACoin:
            [self performSegueWithIdentifier:@"HeadsOrTails" sender:nil];
            break;
        case rollADie:
            [self performSegueWithIdentifier:@"RollADie" sender:nil];
            break;
        case resetAllCounters:
            [self resetAllCounters];
            break;
            
        default:
            break;
    }
 
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) resetAllCounters {
    
    [self.delegate resetCounters];
    [self.revealViewController revealToggleAnimated:YES];
   
}

- (void) getToSearchController {
     [self.revealViewController revealToggleAnimated:NO];
    [self.delegate jumpToSearch];
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

        [self.navigationController popViewControllerAnimated:YES];
        [self.revealViewController revealToggleAnimated:YES];
}



@end
