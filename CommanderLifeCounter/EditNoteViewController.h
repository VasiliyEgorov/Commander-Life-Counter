//
//  EditNoteViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteManagedObject+CoreDataClass.h"
#import "NoteDetailsManagedObject+CoreDataClass.h"
#import "AlertViewData.h"

@interface EditNoteViewController : UIViewController <AlertViewProtocol>

@property (strong, nonatomic) NoteManagedObject *noteDetails;
@property (strong, nonatomic) NoteDetailsManagedObject *noteDetailsManagedObject;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@property (strong, nonatomic) IBOutletCollection(UIBarButtonItem) NSArray *barButtons;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *topActionButton;

- (IBAction)saveNote:(UIBarButtonItem*)sender;
- (IBAction)deleteNote:(UIBarButtonItem*)sender;
- (IBAction)activityAction:(UIBarButtonItem *)sender;
- (IBAction)cameraButtonAction:(UIBarButtonItem *)sender;
@end
