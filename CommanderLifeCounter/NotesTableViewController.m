//
//  Notes1TableViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "NotesTableViewController.h"
#import "EditNoteViewController.h"
#import "CustomNoteCell.h"
#import "NSManagedObjectContext+Category.h"
#import "Constants.h"

@interface NotesTableViewController () <UIGestureRecognizerDelegate>



@end

@implementation NotesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self initRightSwipes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self tableviewSettings];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self deleteRowWithNoText];
}
- (void) tableviewSettings {
    
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationController.toolbarHidden = NO;
    self.tableView.editing = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[UIButton appearance] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
   
   }

- (NSManagedObjectContext*)managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [DataManager sharedManager].mainQueueContext;
    }
    return  _managedObjectContext;
    
}

#pragma mark - Swipes

- (void) initRightSwipes {
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    rightSwipe.delegate = self;
    
    [self.view addGestureRecognizer:rightSwipe];
    
}

- (void) handleRightSwipe:(UISwipeGestureRecognizer*) recognizer {
    self.tabBarController.selectedIndex = 0;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
#pragma mark - Actions

- (IBAction)actionEditButton:(UIBarButtonItem*)sender {
    
    BOOL isEditing = self.tableView.editing;
    
    [self.tableView setEditing:!isEditing animated:YES];
    
    
    if (self.tableView.editing) {
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionEditButton:)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:YES];
    }
    else {
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(actionEditButton:)];
        
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    }
    
}

- (IBAction)addNoteAction:(id)sender {
 
    [self performSegueWithIdentifier:@"editSegue" sender:nil];
    
}

- (IBAction)jumpToPlayerCountersAction:(UIBarButtonItem *)sender {
    
   self.tabBarController.selectedIndex = 0;
}

- (IBAction)jumpToManaCountersAction:(UIBarButtonItem *)sender {
    
   self.tabBarController.selectedIndex = 1;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"editSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NoteManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        EditNoteViewController *vc = (EditNoteViewController*)segue.destinationViewController;
        [vc setNoteDetails:object];
        [vc setNoteDetailsManagedObject:object.noteDetailsRelation];
        
    }
    }

#pragma mark - Table View

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomNoteCell *cell = (CustomNoteCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgForCellHighlighted.png"]];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomNoteCell *cell = (CustomNoteCell*)[tableView cellForRowAtIndexPath:indexPath];
    UIColor *color = [UIColor clearColor];
    cell.backgroundColor = color; 
    cell.contentView.backgroundColor = color;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"editSegue" sender:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotesCell" forIndexPath:indexPath];
    NoteManagedObject *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self configureCell:cell withNote:note];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
}


- (void)configureCell:(CustomNoteCell *)cell withNote:(NoteManagedObject *)note {
    
    cell.cellTextLabel.text = note.noteString;
    cell.dateLabel.text = note.dateString;
    cell.cellDetailedTextLabel.text = note.detailedString;
    
    if (note.placeholderForCell != nil) {

        cell.placeholder.image = [UIImage imageWithData:note.placeholderForCell];
    } else {
        cell.placeholder.image = nil;
    }
    
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController<NoteManagedObject *> *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<NoteManagedObject *> *fetchRequest = NoteManagedObject.fetchRequest;
    
    
    [fetchRequest setFetchBatchSize:20];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    
    NSFetchedResultsController<NoteManagedObject *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
       
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withNote:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

#pragma mark - Delete empty rows

- (void) deleteRowWithNoText {
    
    NSArray *array = [self.managedObjectContext obtainArrayOfManagedObjectsWithEntityName:@"NoteManagedObject" andPredicate:nil];

    for (NoteManagedObject *object in array) {
        if ([object.noteString isEqualToString:NOTEXT] && object.placeholderForCell == nil) {
            [self.managedObjectContext deleteObject:object];
        }
    }
    [self saveContext];
}



#pragma mark - Save

- (void) saveContext {
    
    if ([self.managedObjectContext hasChanges]) {
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }
    
}
@end
