//
//  EditNoteViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "EditNoteViewController.h"
#import "DataManager.h"
#import "NoteData.h"
#import "Constants.h"
#import "NSManagedObjectContext+Category.h"
#import "UIColor+Category.h"
#import "NotesPaintViewController.h"
#import "UIImage+Category.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
#define OFFSET 6


static NSString *const keyboardAddButtonBottom = @"keyboardAddButtonBottom";
static NSString *const keyboardOtherButtonsBottom = @"keyboardOtherButtonsBottom";

@interface EditNoteViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, NotesPaintProtocol>

@property (strong, nonatomic) NoteData *data;
@property (strong, nonatomic) UIButton *keyboardAddButton;
@property (strong, nonatomic) UIButton *keyboardCameraButton;
@property (strong, nonatomic) UIButton *keyboardDoodleButton;
@property (strong, nonatomic) UIButton *keyboardCircleButton;
@property (strong, nonatomic) UIButton *keyboardCloseButton;
@property (strong, nonatomic) AlertViewData *alertViewData;
@property (assign, nonatomic, getter=isSelected) BOOL selected;

@end

@implementation EditNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self controllerSettings];
    [self initObjects];
    [self initNotificationCenter];
    [self saveContext];
    [self initRightSwipes];
    [self makeKeyboardAddButton];
    [self.view layoutIfNeeded];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
   
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if ([self.noteTextView.attributedText length] == 0) {
        [self.noteTextView becomeFirstResponder];
    }
    
}



- (void)controllerSettings {
    
    self.noteTextView.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *myBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage
                                                                            imageNamed:@"backButton.png"] style:UIBarButtonItemStylePlain target:self
                                                                    action:@selector(goBack:)];
    self.navigationItem.backBarButtonItem = myBackButton;
    
}

- (void) initObjects {
    
    if (!_noteDetails) {
        
        _noteDetails = [[NoteManagedObject alloc] initWithContext:self.managedObjectContext];
        _noteDetails.timestamp = [NSDate date];
        _noteDetails.dateString = [self.data dateForCell:_noteDetails.timestamp];
        _noteDetailsManagedObject = [[NoteDetailsManagedObject alloc] initWithContext:self.managedObjectContext];
        _noteDetailsManagedObject.timestamp = _noteDetails.timestamp;
        _noteDetailsManagedObject.attributedText = [[NSAttributedString alloc] initWithString:EMPTY
                                                                      attributes:
                                       @{ NSForegroundColorAttributeName :[UIColor color_150withAlpha:1],
                                          NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:19] }];
        _noteDetails.noteDetailsRelation = _noteDetailsManagedObject;
        [self saveContext];
        
    }
    
    self.noteTextView.attributedText = (NSAttributedString*)_noteDetailsManagedObject.attributedText;
    self.noteTextView.delegate = self;
    self.alertViewData = [[AlertViewData alloc] init];
    self.alertViewData.delegate = self;
    self.alertViewData.presentingController = self;
    self.noteTextView.textContainerInset = UIEdgeInsetsMake(10, -5, 10, -5);
    self.noteTextView.tintColor = [UIColor color_150withAlpha:1];
}



- (void) setNoteTextView:(UITextView *)noteTextView {
    if (_noteTextView != noteTextView) {
        _noteTextView = noteTextView;
    }
   
    
}

- (NoteData*) data {
    if (!_data) {
        _data = [[NoteData alloc] init];
    }
    return _data;
}

- (NSManagedObjectContext*)managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [DataManager sharedManager].mainQueueContext;
    }
    return  _managedObjectContext;
    
}

- (void) saveContextOnBackgroundThread {
    
    NSManagedObjectContext *privateContext = [DataManager sharedManager].privateQueueContext;
    
    if ([privateContext hasChanges]) {
        NSError *error = nil;
        [privateContext save:&error];
    }
    
}

- (void)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Actions

- (IBAction)saveNote:(UIBarButtonItem*)sender {
    
    [self.view endEditing:YES];
    
}

- (IBAction)deleteNote:(UIBarButtonItem*)sender {
    [self.managedObjectContext deleteObject:_noteDetails];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)activityAction:(UIBarButtonItem *)sender {
    
    NSArray *activityItems = [NSArray arrayWithObject:self.noteTextView.text];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityController animated:YES completion:nil];
    
}

- (IBAction)cameraButtonAction:(id)sender {
    
    [self.alertViewData showAlertStandart];
    
}

- (void) doodleButtonAction:(UIButton*)button {
    
    NotesPaintViewController *paintController = [[NotesPaintViewController alloc] initWithNibName:@"NotesPaintViewControllerXIB" bundle:nil];
    paintController.notesDelegate = self;
    [self.navigationController pushViewController:paintController animated:YES];
}

- (void) addButtonAction:(UIButton*)button {
    
    [self rotateAnimationForKeyboardAddButton];
}

- (void) circleButtonAction:(UIButton*)button {
    
   self.noteTextView.attributedText = [self.data placeCircleInTextView:self.noteTextView];
    
}

- (void) closeButtonAction:(UIButton*)button {
    [self rotateAnimationForKeyboardCloseButton];
}

#pragma mark - Swipes

- (void) initRightSwipes {
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    [self.view addGestureRecognizer:rightSwipe];
    
}

- (void) handleRightSwipe:(UISwipeGestureRecognizer *)recognizer {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - NotesPaint protocol

- (void) receiveImage:(UIImage*)image {
    
     self.noteTextView.attributedText = [self.data placePhoto:image inTextView:self.noteTextView];
}

#pragma mark UITextView Delegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    _noteDetails.noteString = [self.data splitTextForCell:textView.attributedText withNoteString:_noteDetails.noteString];
    _noteDetails.detailedString = [self.data splitTextForCell:textView.attributedText withDetailedString:_noteDetails.detailedString];
    [self saveContext];
    
    dispatch_async(kBgQueue, ^{
        
        _noteDetails.placeholderForCell = [self.data searchForImageInAttributedText:self.noteTextView.attributedText];
        _noteDetailsManagedObject.attributedText = textView.attributedText;
        [self saveContextOnBackgroundThread];
    });
}

#pragma mark - AlertViewProtocol

- (void) presentActionSheet:(UIAlertController *)actionSheet {
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) presentImagePicker:(UIImagePickerController *)picker {
    [self presentViewController:picker animated:YES completion:nil];
}
- (void) presentCameraController:(UIViewController *)camera {
    [self presentViewController:camera animated:YES completion:nil];
}

- (void) sendImageFromPicker:(UIImage*)image {
    UIImage *scaled = [UIImage scaleImage:image toFrame:self.noteTextView.frame];
    self.noteTextView.attributedText = [self.data placePhoto:scaled inTextView:self.noteTextView];
    
}


#pragma mark - Keyboard Buttons

- (void) makeKeyboardAddButton {
    
    self.keyboardAddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.keyboardAddButton.frame = CGRectZero;
    [self.keyboardAddButton setBackgroundImage:[UIImage imageNamed:@"keyboardAddButton.png"] forState:UIControlStateNormal];
    [self.keyboardAddButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.keyboardAddButton];
    [self.view bringSubviewToFront:self.keyboardAddButton];
    [self addConstraintsToKeyboardAddButton:self.keyboardAddButton andSelfView:self.view];
    
    [self makeOtherKeyboardsButtons];

}

- (void) addConstraintsToKeyboardAddButton:(UIButton*)addButton andSelfView:(UIView*)selfView {
    
     NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0
                                                             multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 12];
     NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:addButton attribute:NSLayoutAttributeWidth multiplier:1/1 constant:0];
     NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeBottom multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 12];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:addButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:selfView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-OFFSET];
    
    bottom.identifier = keyboardAddButtonBottom;
    
    [selfView addConstraint:bottom];
    [selfView addConstraint:trailing];
    [addButton addConstraint:width];
    [addButton addConstraint:aspectRatio];
    
    addButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) makeOtherKeyboardsButtons {
 
    self.keyboardCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.keyboardCameraButton.frame = CGRectZero;
    [self.keyboardCameraButton setBackgroundImage:[UIImage imageNamed:@"cameraButton.png"] forState:UIControlStateNormal];
    [self.keyboardCameraButton addTarget:self action:@selector(cameraButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.keyboardCameraButton];
    
    
    self.keyboardDoodleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.keyboardDoodleButton.frame = CGRectZero;
    [self.keyboardDoodleButton setBackgroundImage:[UIImage imageNamed:@"doodle.png"] forState:UIControlStateNormal];
    [self.keyboardDoodleButton addTarget:self action:@selector(doodleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.keyboardDoodleButton];
    
    
    self.keyboardCircleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.keyboardCircleButton.frame = CGRectZero;
    [self.keyboardCircleButton setBackgroundImage:[UIImage imageNamed:@"keyboardCircle.png"] forState:UIControlStateNormal];
    [self.keyboardCircleButton addTarget:self action:@selector(circleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.keyboardCircleButton];
    
    self.keyboardCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.keyboardCloseButton.frame = CGRectZero;
    [self.keyboardCloseButton setBackgroundImage:[UIImage imageNamed:@"keyboardClose.png"] forState:UIControlStateNormal];
    [self.keyboardCloseButton addTarget:self action:@selector(closeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.keyboardCloseButton];
    
    self.keyboardCameraButton.hidden = YES;
    self.keyboardDoodleButton.hidden = YES;
    self.keyboardCircleButton.hidden = YES;
    self.keyboardCloseButton.hidden = YES;
    
    CGFloat offsetBetweenButtons = ([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width / 13 - (OFFSET * 4)) / 4;
    
    NSLayoutConstraint *cameraWidth = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 13];
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *cameraBottom = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 13];
    NSLayoutConstraint *cameraAspectRatio = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.keyboardCameraButton attribute:NSLayoutAttributeWidth multiplier:1/1 constant:0];
    
    cameraBottom.identifier = keyboardOtherButtonsBottom;
    
    [self.keyboardCameraButton addConstraint:cameraWidth];
    [self.view addConstraint:centerX];
    [self.keyboardCameraButton addConstraint:cameraAspectRatio];
    [self.view addConstraint:cameraBottom];
    
    self.keyboardCameraButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    NSLayoutConstraint *doodleEqualWidth = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.keyboardDoodleButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
     NSLayoutConstraint *doodleEqualHeight = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.keyboardDoodleButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *doodleTrailing = [NSLayoutConstraint constraintWithItem:self.keyboardDoodleButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.keyboardCameraButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:- offsetBetweenButtons];
    NSLayoutConstraint *doodleBottom = [NSLayoutConstraint constraintWithItem:self.keyboardDoodleButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 13];
    
    doodleBottom.identifier = keyboardOtherButtonsBottom;
    
    [self.view addConstraint:doodleEqualWidth];
    [self.view addConstraint:doodleEqualHeight];
    [self.view addConstraint:doodleTrailing];
    [self.view addConstraint:doodleBottom];
    
    self.keyboardDoodleButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *circleEqualWidth = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.keyboardCircleButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint *circleEqualHeight = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.keyboardCircleButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *circleTrailing = [NSLayoutConstraint constraintWithItem:self.keyboardCircleButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.keyboardDoodleButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:- offsetBetweenButtons];
    NSLayoutConstraint *circleBottom = [NSLayoutConstraint constraintWithItem:self.keyboardCircleButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 13];
    
    circleBottom.identifier = keyboardOtherButtonsBottom;
    
    [self.view addConstraint:circleEqualWidth];
    [self.view addConstraint:circleEqualHeight];
    [self.view addConstraint:circleTrailing];
    [self.view addConstraint:circleBottom];
    
    self.keyboardCircleButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    
    NSLayoutConstraint *closeEqualWidth = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.keyboardCloseButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint *closeEqualHeight = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.keyboardCloseButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    NSLayoutConstraint *closeBottom = [NSLayoutConstraint constraintWithItem:self.keyboardCloseButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 13];
    NSLayoutConstraint *closeLeading = [NSLayoutConstraint constraintWithItem:self.keyboardCameraButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.keyboardCloseButton attribute:NSLayoutAttributeLeading multiplier:1 constant:- offsetBetweenButtons * 1.5];
    
    closeBottom.identifier = keyboardOtherButtonsBottom;
    
    [self.view addConstraint:closeEqualWidth];
    [self.view addConstraint:closeEqualHeight];
    [self.view addConstraint:closeBottom];
    [self.view addConstraint:closeLeading];
    
    self.keyboardCloseButton.translatesAutoresizingMaskIntoConstraints = NO;
    
}



#pragma mark - Animations


- (void) animationAppearanceForKeyboardButtons:(BOOL)hidden {

 
    [self.view layoutIfNeeded];
    
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if ([constraint.identifier isEqualToString:keyboardAddButtonBottom]) {
            constraint.constant = - CURRENT_KEYBOARDHEIGHT - OFFSET;
            break;
        }
    }
    
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if ([constraint.identifier isEqualToString:keyboardOtherButtonsBottom]) {
            constraint.constant = - CURRENT_KEYBOARDHEIGHT - (OFFSET / 2);
            
        }
    }
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         self.keyboardCameraButton.hidden = hidden;
                         self.keyboardDoodleButton.hidden = hidden;
                         self.keyboardCircleButton.hidden = hidden;
                         self.keyboardCloseButton.hidden = hidden;
                         
                         if (self.isSelected) {
                             
                             [self animationForCloseButton];
                         }
                     }];
    
}

- (void) animationDisappearanceForKeyboardButtons {

    [self.view layoutIfNeeded];
    
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if ([constraint.identifier isEqualToString:keyboardOtherButtonsBottom]) {
            constraint.constant = CURRENT_KEYBOARDHEIGHT + (OFFSET / 2) + self.keyboardDoodleButton.frame.size.height;
            
        }
    }
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if ([constraint.identifier isEqualToString:keyboardAddButtonBottom]) {
            constraint.constant = CURRENT_KEYBOARDHEIGHT + OFFSET + self.keyboardAddButton.frame.size.height;
            break;
        }
    }
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionLayoutSubviews
                     animations:^{
                         
                         [self.view layoutIfNeeded];
                         
                     } completion:nil];
}

- (void) animationForCloseButton {
    
    CGAffineTransform newTransform = CGAffineTransformMakeScale(1.2, 1.2);
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         
                         [UIView setAnimationRepeatCount:1.5];
                         
                         self.keyboardCloseButton.transform = newTransform;
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.15
                                               delay:0
                                             options:UIViewAnimationOptionBeginFromCurrentState
                                          animations:^{
                                              
                                              self.keyboardCloseButton.transform = CGAffineTransformIdentity;
                                          } completion:nil];

                     }];
}

- (void) rotateAnimationForKeyboardAddButton {
    
    CGFloat degrees = - 225;
    float percentDeltaHeight = 100 * ((self.keyboardCloseButton.frame.size.height - self.keyboardAddButton.frame.size.height ) / self.keyboardCloseButton.frame.size.height);
    CGAffineTransform newScale = CGAffineTransformMakeScale(1 - (percentDeltaHeight / 100), 1 - (percentDeltaHeight / 100));
    CGAffineTransform rotation = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    CGPoint newCenter = CGPointMake(self.keyboardCloseButton.center.x, self.keyboardCloseButton.center.y);
    CGPoint oldCenter = self.keyboardAddButton.center;

    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.keyboardAddButton.center = newCenter;
                         self.keyboardAddButton.transform = CGAffineTransformConcat(newScale, rotation);
                         
                         
                     }completion:^(BOOL finished) {
                   
                         self.keyboardCameraButton.hidden = NO;
                         self.keyboardDoodleButton.hidden = NO;
                         self.keyboardCircleButton.hidden = NO;
                         self.keyboardCloseButton.hidden = NO;
                         self.keyboardAddButton.hidden = YES;
                         self.keyboardAddButton.transform = CGAffineTransformIdentity;
                         self.keyboardAddButton.center = oldCenter;
                         self.selected = YES;
                     }];
}

- (void) rotateAnimationForKeyboardCloseButton {
    
    CGFloat degrees = 225;
     float percentDeltaHeight = 100 * ((self.keyboardAddButton.frame.size.height - self.keyboardCloseButton.frame.size.height) / self.keyboardAddButton.frame.size.height);
    CGAffineTransform newScale = CGAffineTransformMakeScale(1 - (percentDeltaHeight / 100), 1 - (percentDeltaHeight / 100));
    CGAffineTransform rotation = CGAffineTransformMakeRotation(degrees * M_PI / 180);
    CGPoint newCenter = CGPointMake(self.keyboardAddButton.center.x, self.keyboardAddButton.center.y);
    CGPoint oldCenter = self.keyboardCloseButton.center;
   
    [UIView animateWithDuration:0.5
                     animations:^{
                         
                         self.keyboardCloseButton.center = newCenter;
                         self.keyboardCloseButton.transform = CGAffineTransformConcat(newScale, rotation);
                        
                         
                     }completion:^(BOOL finished) {
 
                         self.keyboardCameraButton.hidden = YES;
                         self.keyboardDoodleButton.hidden = YES;
                         self.keyboardCircleButton.hidden = YES;
                         self.keyboardCloseButton.hidden = YES;
                         
                         self.keyboardAddButton.hidden = NO;
                         
                         self.keyboardCloseButton.transform = CGAffineTransformIdentity;
                         self.keyboardCloseButton.center = oldCenter;
                        
                         self.selected = NO;
                         
                     }];
}

#pragma mark - Notifications

- (void) initNotificationCenter {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(notificationKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [nc addObserver:self selector:@selector(notificationUserDidType:) name:UITextViewTextDidChangeNotification object:nil];
    [nc addObserver:self selector:@selector(notificationKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) notificationKeyboardWillShow:(NSNotification*) notification {

    NSDictionary *dictionary = [notification userInfo];
    CGSize keyboardSize = [[dictionary objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat totalOffset = keyboardSize.height + OFFSET;
    [self.noteTextView setContentInset:UIEdgeInsetsMake(0, 0, totalOffset, 0)];
    [self.noteTextView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, totalOffset, 0)];
    
    CURRENT_KEYBOARDHEIGHT = totalOffset;
    
    if (!self.isSelected) {
        
        [self animationAppearanceForKeyboardButtons:YES];
    }
    else {
        
        [self animationAppearanceForKeyboardButtons:NO];
    }
    
 
    if ([self.noteTextView.attributedText.string isEqualToString:EMPTY]) {
        
        self.topActionButton.enabled = NO;
    }
    else {
        self.topActionButton.enabled = YES;
    }
    
    
}



- (void) notificationUserDidType:(NSNotification*) notification {
    
    if ([self.noteTextView.attributedText.string isEqualToString:EMPTY]) {
        
        self.topActionButton.enabled = NO;
    }
    else {
        self.topActionButton.enabled = YES;
    }
}

- (void) notificationKeyboardWillHide:(NSNotification*) notification {
    
    NSDictionary *dictionary = [notification userInfo];
    CGSize keyboardSize = [[dictionary objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
   
    CGFloat delta = keyboardSize.height - CURRENT_KEYBOARDHEIGHT;

    [self animationDisappearanceForKeyboardButtons];
 
    [self.noteTextView setContentInset:UIEdgeInsetsMake(0, 0, delta, 0)];
    [self.noteTextView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, delta, 0)];
    
    if ([self.noteTextView.attributedText.string isEqualToString:EMPTY]) {
        self.topActionButton.enabled = NO;
    }
    else {
        self.topActionButton.enabled = YES;
    }
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Save

- (void) saveContext {
    
    if ([self.managedObjectContext hasChanges]) {
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }
    
}
@end
