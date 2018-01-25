//
//  NotesPaintViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 27.09.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "NotesPaintViewController.h"
#import "UIColor+Category.h"
#import "ColorPaletteForDoodle.h"
#import "AvatarEditProtocols.h"
#import "UIImage+Category.h"

@interface NotesPaintViewController () <ControllerToDoodleProtocol>

@property (strong, nonatomic) UIButton *undoButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (weak, nonatomic) id <DoodleToControllerProtocol> delegate;
@property (strong, nonatomic) ColorPaletteForDoodle *colorPalette;

@end

@implementation NotesPaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addConstraintToButtonsLayerView:self.buttonsLayerView andToDoodleView:self.doodleView];
    [self configureButtons];
    [self configureColorPalette];
    [self configureButtonsLayerView];
    self.doodleView.userInteractionEnabled = YES;
    self.doodleView.delegate = self.colorPalette;
    self.doodleView.controllerToDoodleDelegate = self;
    self.delegate = self.doodleView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *useButton = [[UIBarButtonItem alloc] initWithTitle:@"Use" style:UIBarButtonItemStylePlain target:self action:@selector(useButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = useButton;
    
    self.navigationController.toolbarHidden = YES;
    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.toolbarHidden = NO;
}

#pragma mark - Constraints

- (void)addConstraintToButtonsLayerView:(UIView*)buttonsLayerView  andToDoodleView:(UIView*)doodleView {
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:buttonsLayerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:doodleView attribute:NSLayoutAttributeBottom multiplier:1 constant:-1];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:buttonsLayerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:buttonsLayerView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:buttonsLayerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self.view addConstraint:top];
    [self.view addConstraint:leading];
    [self.view addConstraint:trailing];
    [self.view addConstraint:bottom];
    
    buttonsLayerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

#pragma mark - Color palette

- (void) configureColorPalette {
    
    
    self.colorPalette = [[ColorPaletteForDoodle alloc] initWithFrame:CGRectNull];
    [self.view addSubview:self.colorPalette];
    [self.view bringSubviewToFront:self.colorPalette];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.doodleView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPalette attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.buttonsLayerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colorPalette attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.colorPalette attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:16];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.colorPalette attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    [self.view addConstraint:top];
    [self.view addConstraint:bottom];
    [self.colorPalette addConstraint:width];
    [self.view addConstraint:trailing];
    
    self.colorPalette.translatesAutoresizingMaskIntoConstraints = NO;
    
}

#pragma mark - Buttons

- (void) configureButtons {
    
    self.undoButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.undoButton.frame = CGRectZero;
    [self.undoButton setTitle:@"Undo" forState:UIControlStateNormal];
    [self.undoButton addTarget:self action:@selector(undoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.undoButton setTitleColor:[UIColor color_150withAlpha:1] forState:UIControlStateNormal];
    [self.undoButton setTitleColor:[UIColor color_150withAlpha:0.4] forState:UIControlStateDisabled];
    self.undoButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:[UIScreen mainScreen].bounds.size.width / 12];
    self.undoButton.backgroundColor = [UIColor clearColor];
    
    self.resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.resetButton.frame = CGRectZero;
    [self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    [self.resetButton addTarget:self action:@selector(resetButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.resetButton setTitleColor:[UIColor color_150withAlpha:1] forState:UIControlStateNormal];
    [self.resetButton setTitleColor:[UIColor color_150withAlpha:0.4] forState:UIControlStateDisabled];
    self.resetButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:[UIScreen mainScreen].bounds.size.width / 12];
    self.resetButton.backgroundColor = [UIColor clearColor];
    
    [self.buttonsLayerView addSubview:self.undoButton];
    [self.buttonsLayerView addSubview:self.resetButton];
    
    self.undoButton.enabled = NO;
    self.resetButton.enabled = NO;
    
    NSLayoutConstraint *undoTop = [NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *undoBottom = [NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *undoLeading = [NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *undoWidth = [NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 2];
    
    [self.buttonsLayerView addConstraint:undoTop];
    [self.buttonsLayerView addConstraint:undoBottom];
    [self.buttonsLayerView addConstraint:undoLeading];
    [self.undoButton addConstraint:undoWidth];
    
    self.undoButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *resetTop = [NSLayoutConstraint constraintWithItem:self.resetButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *resetBottom = [NSLayoutConstraint constraintWithItem:self.resetButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    NSLayoutConstraint *resetTrailing = [NSLayoutConstraint constraintWithItem:self.resetButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.buttonsLayerView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    NSLayoutConstraint *resetWidth = [NSLayoutConstraint constraintWithItem:self.resetButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:[UIScreen mainScreen].bounds.size.width / 2];
    
    [self.buttonsLayerView addConstraint:resetTop];
    [self.buttonsLayerView addConstraint:resetBottom];
    [self.buttonsLayerView addConstraint:resetTrailing];
    [self.resetButton addConstraint:resetWidth];
    
    self.resetButton.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void) configureButtonsLayerView {
    
    CAShapeLayer *border = [CAShapeLayer new];
    border.backgroundColor = [UIColor whiteColor].CGColor;
    border.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    [self.buttonsLayerView.layer addSublayer:border];
}

#pragma mark - Actions

- (IBAction)resetButtonAction:(UIButton *)sender {
    
    [self.delegate resetButton];
}

- (IBAction)undoButtonAction:(UIButton *)sender {
    
    [self.delegate undoButton];
    
}

- (void) cancelButtonAction:(UIButton*) button {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) useButtonAction:(UIButton*) button {
    
   NSArray *pathsArray = [self.delegate receivePathsArray];
    NSMutableArray *arrayWithOriginsY = [NSMutableArray array];
    NSMutableArray *arrayWithRects = [NSMutableArray array];
    for (UIBezierPath *path in pathsArray) {
        CGRect frame = [self.doodleView convertRect:path.bounds toView:self.doodleView];
        [arrayWithOriginsY addObject:[NSNumber numberWithFloat:frame.origin.y]];
        [arrayWithRects addObject:[NSValue valueWithCGRect:frame]];
        
        
    }
    NSArray *originsSorted = [arrayWithOriginsY sortedArrayUsingSelector:@selector(compare:)];
    NSArray *heightsSorted = [arrayWithRects sortedArrayUsingComparator:^NSComparisonResult(NSValue *objOne, NSValue *objeTwo) {
        
        CGRect rectMin = [objOne CGRectValue];
        CGRect rectMax = [objeTwo CGRectValue];
        
        if (rectMin.size.height + rectMin.origin.y < rectMax.size.height + rectMax.origin.y){
            
            return NSOrderedAscending;
        }
        else {
            return NSOrderedDescending;
        }
    }];
    
    NSNumber *originMinValue = [originsSorted firstObject];
    CGFloat originMinY = [originMinValue floatValue];
    
    NSNumber *originMaxValue = [originsSorted lastObject];
    CGFloat originMaxY = [originMaxValue floatValue];
    
    NSNumber *heightMaxValue = [heightsSorted lastObject];
    CGRect rectMax = [heightMaxValue CGRectValue];
    
   
    CGFloat halfMaxlineWidth = 0;
    CGFloat halfMinlineWidth = 0;
    CGRect frameToCrop;
    
    for (UIBezierPath *path in pathsArray) {
        CGRect frame = [self.doodleView convertRect:path.bounds toView:self.doodleView];
        if (frame.origin.y == originMaxY) {
            halfMaxlineWidth = path.lineWidth / 2;
            
        }
        if (frame.origin.y == originMinY) {
            halfMinlineWidth = path.lineWidth / 2;
        }
    }
    
    
        frameToCrop = CGRectMake(0, originMinY - halfMinlineWidth, self.doodleView.frame.size.width, rectMax.origin.y + rectMax.size.height - originMinY + halfMaxlineWidth + halfMinlineWidth);
   
   
    UIImage *merdgedImage = [UIImage mergeViewAndItsLayer:self.doodleView];
    UIImage *croppedImage = [UIImage cropImage:merdgedImage byCropViewFrames:frameToCrop];
    
    [self.notesDelegate receiveImage:croppedImage];
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UndoAndResetButtons Protocol

- (void) disableButtons {
    
    self.undoButton.enabled = NO;
    self.resetButton.enabled = NO;
}

- (void) enableButtons {
    
    self.undoButton.enabled = YES;
    self.resetButton.enabled = YES;
}

@end
