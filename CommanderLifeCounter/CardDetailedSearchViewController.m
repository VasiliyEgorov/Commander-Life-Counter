//
//  CardDetailedSearchViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 23.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "CardDetailedSearchViewController.h"
#import "CustomDetailedSearchCell.h"
#import "SearchResultsData.h"
#import "SWRevealViewController.h"
#import "CustomNoImageView.h"
#import "CustomRefreshButton.h"
#import "CardDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CardZoomViewController.h"
#import "UIColor+Category.h"

@interface CardDetailedSearchViewController ()

@property (strong, nonatomic) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) CustomRefreshButton *refreshButton;
@property (strong, nonatomic) CustomRefreshButton *clearColorZoomButton;
@property (strong, nonatomic) CardZoomViewController *cardZoomController;

@end

@implementation CardDetailedSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableViewSettings];
    [self initRightSwipes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.toolbarHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) tableViewSettings {
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.navigationItem setTitle:@"Search results"];
   
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    if ([self.resultsArray count] > 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else {
        
        UILabel *noResultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, self.tableView.frame.size.height / 15)];
        noResultsLabel.textColor = [UIColor color_150withAlpha:1];
        noResultsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(noResultsLabel.frame.size.height * 2.5/3)];
        noResultsLabel.textAlignment = NSTextAlignmentCenter;
        noResultsLabel.text = @"No search results";
        noResultsLabel.adjustsFontSizeToFitWidth = YES;
        [self.tableView.backgroundView addSubview:noResultsLabel];
        [self addConstraintsToNoResultLabel:noResultsLabel];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
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

#pragma mark - Table view

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomDetailedSearchCell *cell = (CustomDetailedSearchCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgForCellHighlighted.png"]];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomDetailedSearchCell *cell = (CustomDetailedSearchCell*)[tableView cellForRowAtIndexPath:indexPath];
    UIColor *color = [UIColor clearColor];
    cell.backgroundColor = color;
    cell.contentView.backgroundColor = color;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchResultsData *card = [self.resultsArray objectAtIndex:tableView.indexPathForSelectedRow.row];
    
    [self.searchManager insertIntityWith:card];
    
    [self performSegueWithIdentifier:@"CardDetails" sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.resultsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 121;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *identifier = @"DetailedSearch";
    
    CustomDetailedSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
   
    SearchResultsData *card = [self.resultsArray objectAtIndex:indexPath.row];
    [self configureCell:cell withCard:card];
  
    return cell;
    
}



- (void)configureCell:(CustomDetailedSearchCell*)cell withCard:(SearchResultsData *)card {
    
    cell.backgroundColor = [UIColor clearColor];
    cell.cardNameLabel.text = card.cardName;
    cell.cardTypeLabel.text = card.type;
    cell.cardRarityLabel.text = card.rarity;
    cell.cardLegalitiesLabel.text = [NSString stringWithFormat:@"Legal in: %@", card.legalitiesString];
    cell.cardImage.image = nil;
    for (UIButton *btn in cell.cardImage.subviews) {
        [btn removeFromSuperview];
    }
    [self tryToGetCardImageFor:cell withCardURL:card];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"CardDetails"]) {
        
        CardDetailsViewController *vc = (CardDetailsViewController*)segue.destinationViewController;
        
        vc.card = [self.resultsArray objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}


#pragma mark - Get Card Image

- (void) tryToGetCardImageFor:(CustomDetailedSearchCell*)cell withCardURL:(SearchResultsData*)card {
    
    if (card.urlString != nil) {
       
        
        [cell.cardImage addSubview:self.indicator];
       [self addConstraintsToView:self.indicator andToCellsImage:cell];
        [self.indicator setHidden:NO];
        [self.indicator startAnimating];
    }
    else {
        
        [self addNoSignImageViewToCell:cell];
   
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
   
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:card.urlString]];
   __weak CustomDetailedSearchCell *weakCell = cell;
    [weakCell.cardImage setImageWithURLRequest:request
                              placeholderImage:nil
                                       success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
                                        
                                           weakCell.cardImage.image = image;
                                           
                                            [self addClearColorZoomButtonToCellsImage:weakCell];
                                          
                                             [self.indicator stopAnimating];
                                             [self.indicator setHidden:YES];
                                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                        
 
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.indicator stopAnimating];
        [self.indicator setHidden:YES];
        cell.cardImage.image = [UIImage imageNamed:@"cardBlur.png"];
        [self addRefreshButtonToCellsImage:cell];
        
        
    }];
   
    
}


- (void) addCardZoomController {
    self.cardZoomController = [[CardZoomViewController alloc] init];
    [self.cardZoomController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self.cardZoomController setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
}

#pragma mark - Buttons

- (void) addNoSignImageViewToCell:(CustomDetailedSearchCell*)cell {
    
    CustomNoImageView *noSignImageView = [[CustomNoImageView alloc] initWithImage:[UIImage imageNamed:@"noImageSign.png"]];
    
    [cell.cardImage addSubview:noSignImageView];
    [self addConstraintsToView:noSignImageView andToCellsImage:cell];
}

- (void) addRefreshButtonToCellsImage:(CustomDetailedSearchCell*)cell {
    
    self.refreshButton = [CustomRefreshButton buttonWithType:UIButtonTypeSystem];
    self.refreshButton.frame = CGRectMake(0, 0, 50, 50);
    [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"refreshForCard.png"] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(refreshButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.cardImage addSubview:self.refreshButton];
    
    [self addConstraintsToView:self.refreshButton andToCellsImage:cell];
    
    cell.cardImage.userInteractionEnabled = YES;
}

- (void) addClearColorZoomButtonToCellsImage:(CustomDetailedSearchCell*)cell {
    self.clearColorZoomButton = [CustomRefreshButton buttonWithType:UIButtonTypeSystem];
    self.clearColorZoomButton.frame = CGRectMake(0, 0, cell.cardImage.frame.size.width, cell.cardImage.frame.size.height);
    self.clearColorZoomButton.backgroundColor = [UIColor clearColor];
    
    [self.clearColorZoomButton addTarget:self action:@selector(clearColorZoomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.cardImage addSubview:self.clearColorZoomButton];
    
    [self addConstraintsToClearColorZoomButton:self.clearColorZoomButton andToCell:cell];
    
    cell.cardImage.userInteractionEnabled = YES;
}

- (void) refreshButtonAction:(id)sender {
    
    [self.tableView reloadData];
    
}

- (void) clearColorZoomButtonAction:(UIButton*)sender {
    
    CGPoint buttonOrigin = sender.frame.origin;
    CGPoint pointInTableview = [self.tableView convertPoint:buttonOrigin fromView:sender.superview];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:pointInTableview];
    
    if (indexPath) {
        
        [self addCardZoomController];
        [self presentViewController:self.cardZoomController animated:YES completion:nil];
        CustomDetailedSearchCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self.cardZoomController placeImageToImageView:cell.cardImage.image];
    }
}

#pragma mark - Constraints

- (void) addConstraintsToView:(UIView*)view andToCellsImage:(CustomDetailedSearchCell*)cell {
    
    CGFloat multiplierHeight;
    CGFloat multiplierWidth;
    
    if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
        multiplierHeight = 0.2;
        multiplierWidth = 0.4;
    } else if ([view isKindOfClass:[CustomRefreshButton class]]) {
        multiplierHeight = 0.32;
        multiplierWidth = 0.5;
    } else {
        multiplierHeight = 0.28;
        multiplierWidth = 0.45;
    }
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.cardImage attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.cardImage attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:cell.cardImage attribute:NSLayoutAttributeHeight multiplier:multiplierHeight constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:cell.cardImage attribute:NSLayoutAttributeWidth multiplier:multiplierWidth constant:0];
    
    [cell.cardImage addConstraint:centerX];
    [cell.cardImage addConstraint:centerY];
    [cell.cardImage addConstraint:height];
    [cell.cardImage addConstraint:width];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

- (void) addConstraintsToClearColorZoomButton:(UIButton*)button andToCell:(CustomDetailedSearchCell*)cell {
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.cardImage attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.cardImage attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.cardImage attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.cardImage attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];

    [cell.cardImage addConstraint:top];
    [cell.cardImage addConstraint:bottom];
    [cell.cardImage addConstraint:leading];
    [cell.cardImage addConstraint:trailing];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;

}

- (void) addConstraintsToNoResultLabel:(UILabel*)label {
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.tableView.backgroundView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.tableView.backgroundView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];

    [self.tableView.backgroundView addConstraint:centerX];
    [self.tableView.backgroundView addConstraint:centerY];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
}

#pragma mark - Actions


- (IBAction)jumpToManaCounters:(UIBarButtonItem *)sender {
    
    self.tabBar.selectedIndex = 1;
}

- (IBAction)jumpToPlayerCounters:(UIBarButtonItem *)sender {
    
    self.tabBar.selectedIndex = 0;
   
}

- (IBAction)jumpToNotes:(UIBarButtonItem *)sender {
    
    self.tabBar.selectedIndex = 2;
}



@end
