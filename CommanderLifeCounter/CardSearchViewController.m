//
//  CardSearchViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CardSearchViewController.h"
#import "CustomSearchCell.h"
#import "ServerManager.h"
#import "SearchResultsData.h"
#import "CardDetailsViewController.h"
#import "SearchManager.h"
#import "SWRevealViewController.h"
#import "Constants.h"
#import "CardDetailedSearchViewController.h"
#import "AwaitingViewController.h"
#import "UIColor+Category.h"

#define ZERO 0

@interface CardSearchViewController () <UISearchBarDelegate>

@property (strong, nonatomic) SearchManager *searchManager;
@property (strong, nonatomic) NSMutableArray *resultsArray;
@property (strong, nonatomic) NSMutableArray *searchResultsArray;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) AwaitingViewController *awatingController;
@property (strong, nonatomic) NSLayoutConstraint *labelToTopSearchBarConstraint;
@property (strong, nonatomic) UILabel *noConnectionLabel;

@end

@implementation CardSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewSettings];
    [self initObjects];
    [self initRightSwipes];
    [self initKeyboardNotifications];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.toolbarHidden = NO;
    [self.searchBar becomeFirstResponder];
    
}
- (void) tableViewSettings {

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.navigationItem setTitle:@"Card search"];
    
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.tableView.backgroundView addSubview:self.indicator];
    [self addConstraintsToTableView:self.indicator];
    
    self.awatingController = [[AwaitingViewController alloc] init];
    [self.awatingController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.awatingController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [[self searchSubviewsForTextFieldIn:self.searchBar] setBackgroundColor:[UIColor color_99withAlpha:0.1]];
    [[self searchSubviewsForTextFieldIn:self.searchBar] setTextColor:[UIColor color_150withAlpha:1]];
    
   
}


- (void) initRightSwipes {
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe:)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    
}


- (void) handleLeftSwipe:(UISwipeGestureRecognizer*) recognizer {

    self.tabBarController.selectedIndex = 0;
    [self.revealViewController revealToggleAnimated:NO];
 
}

- (void) initObjects {
    if (!_searchManager) {
        _searchManager = [[SearchManager alloc] init];
    }
    self.resultsArray = [NSMutableArray array];
    self.searchResultsArray = [NSMutableArray array];
}


#pragma mark Change color of SearchBar

- (UITextField*)searchSubviewsForTextFieldIn:(UIView*)view {
    
    if ([view isKindOfClass:[UITextField class]]) {
        return (UITextField*)view;
    }
    UITextField *searchedTextField;
    for (UIView *subview in view.subviews) {
        searchedTextField = [self searchSubviewsForTextFieldIn:subview];
        if (searchedTextField) {
            break;
        }
    }
    return searchedTextField;
}



#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    searchBar.text = [self.searchManager insertSearchTextFromContext];
   self.searchBar.showsCancelButton = YES;
    [self startSearchWithText:searchBar.text];
    
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    [self.searchManager insertSearchTextWith:searchBar.text];
    
    [self.indicator setHidden:YES];
    [self.indicator stopAnimating];
    
    [self presentViewController:self.awatingController animated:NO completion:nil];
    
        
    [self.searchManager getSearchedCardsWithHintAndWithName:searchBar.text onSuccess:^(NSArray *array) {
        
            [self.searchResultsArray removeAllObjects];
            [self.searchResultsArray addObjectsFromArray:array];
        

            [self.awatingController dismissViewControllerAnimated:NO completion:^{
                
                [self performSegueWithIdentifier:@"DetailedSearchController" sender:nil];
                 
            }];
       
        
    } onFailure:^(NSError *error) {
      
        [self.awatingController dismissViewControllerAnimated:YES completion:nil];
        [self addNoConnectionLabel];
    }];
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
   self.searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = EMPTY;
    [self.searchManager saveSearchTextToContext:searchBar.text];
    [self startSearchWithText:searchBar.text];
    [self.searchBar resignFirstResponder];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self startSearchWithText:searchText];
    [self.searchManager saveSearchTextToContext:searchText];
    
}

#pragma mark - Search Method

- (void)startSearchWithText:(NSString*)searchText {
    
    [self.resultsArray removeAllObjects];
    [self.searchManager cancelSearch];
    [self.tableView reloadData];
    
    if ([searchText length] > 0) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [self.indicator setHidden:NO];
        [self.indicator startAnimating];
        
        [self.searchManager getNewCardsWithHintAndWithName:searchText onSuccess:^(NSArray *array) {
            if (array) {
                
                [self.resultsArray addObjectsFromArray:array];
                [self.tableView reloadData];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [self.indicator setHidden:YES];
                [self.indicator stopAnimating];
               
            }
        } onFailure:^(NSError *error) {
            
            [self.indicator setHidden:YES];
            [self.indicator stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if (error.code == NOCONNECTION) {
                [self addNoConnectionLabel];
            }
            
        }];
    }
    else {
        
        [self.resultsArray addObjectsFromArray:[self.searchManager historyArray]];
        [self.tableView reloadData];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }

}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"CardDetails"]) {
        
        CardDetailsViewController *vc = (CardDetailsViewController*)segue.destinationViewController;
        
        vc.card = [self.resultsArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
    
    if ([[segue identifier] isEqualToString:@"DetailedSearchController"]) {
        CardDetailedSearchViewController * vc = (CardDetailedSearchViewController*)segue.destinationViewController;
        [vc setResultsArray:self.searchResultsArray];
        [vc setTabBar:self.tabBarController];
        [vc setSearchManager:self.searchManager];
    }
}

#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomSearchCell *cell = (CustomSearchCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgForCellHighlighted.png"]];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomSearchCell *cell = (CustomSearchCell*)[tableView cellForRowAtIndexPath:indexPath];
    UIColor *color = [UIColor clearColor];
    cell.backgroundColor = color;
    cell.contentView.backgroundColor = color;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultsData *card = [self.resultsArray objectAtIndex:tableView.indexPathForSelectedRow.row];
    
    [self.searchBar resignFirstResponder];
    
    
        
    if (card.isntCard) {
        [self presentViewController:self.awatingController animated:NO completion:nil];
        
        [self.searchManager getSearchedCardsWithHintAndWithName:card.cardName onSuccess:^(NSArray *array) {
           
            if (array) {
                
                [self.searchResultsArray removeAllObjects];
                [self.searchResultsArray addObjectsFromArray:array];
                
                    [self.awatingController dismissViewControllerAnimated:NO completion:^{
                        [self performSegueWithIdentifier:@"DetailedSearchController" sender:nil];
                    }];
            }
           
        } onFailure:^(NSError *error) {
            [self.awatingController dismissViewControllerAnimated:YES completion:nil];
            [self addNoConnectionLabel];
        }];
        
    }
    else {
        
    [self.searchManager insertIntityWith:card];
        
            [self performSegueWithIdentifier:@"CardDetails" sender:nil];
 
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.resultsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"SearchCell";
    
    CustomSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    SearchResultsData *card = [self.resultsArray objectAtIndex:indexPath.row];
    [self configureCell:cell withCard:card];
    
    return cell;
}

- (void)configureCell:(CustomSearchCell *)cell withCard:(SearchResultsData *)card {
    cell.backgroundColor = [UIColor clearColor];
    cell.cardNameLabel.text = card.cardName;
    cell.rightArrowImage.image = [UIImage imageNamed:@"arrowForCardCell.png"];
    cell.placeholderImage.image = card.placeHolder;
   

}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - Actions

- (IBAction)backButton:(UIBarButtonItem *)sender {

    self.tabBarController.selectedIndex = 0;
    [self.revealViewController revealToggleAnimated:NO];
}

- (IBAction)jumpToManaCounters:(UIBarButtonItem *)sender {
    
    self.tabBarController.selectedIndex = 1;
}

- (IBAction)jumpToPlayerCounters:(UIBarButtonItem *)sender {
    
    self.tabBarController.selectedIndex = 0;
   
}

- (IBAction)jumpToNotes:(UIBarButtonItem *)sender {
    
    self.tabBarController.selectedIndex = 2;
}



#pragma mark - Constraints

- (void) addConstraintsToTableView:(UIView*)view {
    
 
    if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
        
        CGFloat multiplierHeight = 0.2;
        CGFloat multiplierWidth = 0.4;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.tableView.backgroundView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.tableView.backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.tableView.backgroundView attribute:NSLayoutAttributeHeight multiplier:multiplierHeight constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.tableView.backgroundView attribute:NSLayoutAttributeWidth multiplier:multiplierWidth constant:0];
    
    [self.tableView.backgroundView addConstraint:centerX];
    [self.tableView.backgroundView addConstraint:centerY];
    [self.tableView.backgroundView addConstraint:height];
    [self.tableView.backgroundView addConstraint:width];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    }
    
    else {
        
        NSLayoutConstraint *topMargin = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.searchBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
         NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:self.tableView.frame.size.width];
        self.labelToTopSearchBarConstraint = topMargin;
        [self.view addConstraint:width];
        [self.view addConstraint:centerX];
        [self.view addConstraint:topMargin];
      
        view.translatesAutoresizingMaskIntoConstraints = NO;
        
       
    }
}

#pragma mark - No connection Label

- (void) addNoConnectionLabel {
    
    if (!self.noConnectionLabel) {

    self.noConnectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.searchBar.frame.size.height)];
    
    self.noConnectionLabel.textColor = [UIColor color_20];
    self.noConnectionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:35];
    self.noConnectionLabel.textAlignment = NSTextAlignmentCenter;
    self.noConnectionLabel.backgroundColor = [UIColor color_150withAlpha:1];
    self.noConnectionLabel.text = @"No internet connection";
    self.noConnectionLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.noConnectionLabel];
    [self addConstraintsToTableView:self.noConnectionLabel];
    [self.view bringSubviewToFront:self.searchBar];
    
    [self labelMovesDownAnimation];
    }
}

- (void) labelMovesDownAnimation {
    
    [self.view layoutSubviews];
    
    self.tableViewTopContraint.constant = self.noConnectionLabel.frame.size.height + 4;
    self.labelToTopSearchBarConstraint.constant = self.searchBar.frame.size.height - 2;
    
    [UIView animateWithDuration:0.75
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         [self.view layoutSubviews];
                         
                     } completion:^(BOOL finished) {
                         
                         [self labelMovesUpAnimation];
                     }];
  
}

- (void) labelMovesUpAnimation {
    [self.view layoutSubviews];
    self.tableViewTopContraint.constant = ZERO;
    self.labelToTopSearchBarConstraint.constant = ZERO;
    
    
    [UIView animateWithDuration:0.75
                          delay:2
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         
                         [self.view layoutSubviews];
                         
                     } completion:^(BOOL finished) {
                         
                         [self.noConnectionLabel removeFromSuperview];
                         self.noConnectionLabel = nil;
                     }];
}


#pragma mark - Notifications

- (void) initKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow:(NSNotification*) notification {
    
    NSDictionary *dictionary = [notification userInfo];
    CGSize keyboardSize = [[dictionary objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)];
    
    CURRENT_KEYBOARDHEIGHT = keyboardSize.height;
}

- (void) keyboardWillHide:(NSNotification*) notification {
    
    NSDictionary *dictionary = [notification userInfo];
    CGSize keyboardSize = [[dictionary objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat delta = keyboardSize.height - CURRENT_KEYBOARDHEIGHT;

    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, delta, 0)];
    [self.tableView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, delta, 0)];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   
}
@end
