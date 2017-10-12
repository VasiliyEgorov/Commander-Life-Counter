//
//  Notes1TableViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "NoteManagedObject+CoreDataClass.h"

@interface NotesTableViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSFetchedResultsController<NoteManagedObject *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

- (IBAction)actionEditButton:(UIBarButtonItem*)sender;
- (IBAction)addNoteAction:(id)sender;
- (IBAction)jumpToPlayerCountersAction:(UIBarButtonItem *)sender;
- (IBAction)jumpToManaCountersAction:(UIBarButtonItem *)sender;
@end
