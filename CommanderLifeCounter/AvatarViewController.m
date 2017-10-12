//
//  AvatarViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 21.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "AvatarViewController.h"
#import "UIImage+Category.h"
#import "EditAvatarViewController.h"
#import "AvatarData.h"
#import "UIColor+Category.h"


@interface AvatarViewController () <EditAvatarProtocol>

@property (strong, nonatomic) AvatarData *avatarData;
@property (strong, nonatomic) UIButton *editButton;

@end

@implementation AvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatarData = [[AvatarData alloc] init];
    
    [self.view layoutIfNeeded];
    self.avatarImageView.userInteractionEnabled = YES;
    
   
    [self configureEditButton];
   
    [self.indicator setHidden:NO];
    [self.indicator startAnimating];
    self.editButton.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.toolbarHidden = YES;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *useButton = [[UIBarButtonItem alloc] initWithTitle:@"Use" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = useButton;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.toolbarHidden = NO;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    
            
            [self.avatarData placePhoto:self.originalPhoto forAvatarImageView:self.avatarImageView success:^(UIImage *editedPhoto) {
                
                if (editedPhoto) {
                    
                    self.avatarImageView.image = editedPhoto;
                   
                    [self.indicator setHidden:YES];
                    [self.indicator stopAnimating];
                    self.editButton.hidden = NO;
                    NSLog(@"%f %f", self.originalPhoto.size.width, self.originalPhoto.size.height);
                }
            }];
    


}
- (void) configureEditButton {
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.editButton.frame = CGRectMake(0, 0, 40, 20);
    [self.editButton addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UIFont systemFontOfSize:self.editButton.frame.size.height / 1.2];
    self.editButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.4];
    self.editButton.layer.cornerRadius = 12;
    
    [self.layerView addSubview:self.editButton];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.editButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.layerView attribute:NSLayoutAttributeBottom multiplier:1 constant: -20];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.editButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.layerView attribute:NSLayoutAttributeLeading multiplier:1 constant:20];
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:self.editButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.editButton attribute:NSLayoutAttributeHeight multiplier:2/1 constant:0];
    NSLayoutConstraint *equalHeight = [NSLayoutConstraint constraintWithItem:self.editButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.layerView attribute:NSLayoutAttributeHeight multiplier:0.15 constant:0];
    [self.layerView addConstraint:bottom];
    [self.layerView addConstraint:leading];
    [self.editButton addConstraint:aspectRatio];
    [self.layerView addConstraint:equalHeight];
    
    self.editButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
}

#pragma mark - EditAvatar Protocol

- (void)sendCroppedImageView:(UIImageView*)avatarImageView {
    
    self.originalPhoto = nil;
    
    for (UIView *view in avatarImageView.subviews) {
        [self.avatarImageView addSubview:view];
    }
    self.avatarImageView.image = avatarImageView.image;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.userInteractionEnabled = NO;
    [self.editButton removeFromSuperview];
}


#pragma mark - Actions

- (void) editButtonAction:(UIButton*)button {
   
    EditAvatarViewController *vc = [[EditAvatarViewController alloc] initWithOriginalPhoto:self.originalPhoto];
    
    vc.editedPhotoDelegate = self;
    
    [self presentViewController:vc animated:NO completion:nil];
}


- (void)saveButtonAction:(UIBarButtonItem*)sender {
   
   if (self.counterIndex == 0) {
        [self.avatarData snapshotAvatarImageViewForPlayer:self.avatarImageView andScaleToFrame:self.avatarImageViewFrame];
    }
   else {
        [self.avatarData snapshotAvatarImageViewForOpponent:self.avatarImageView andScaleToFrame:self.avatarImageViewFrame];
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)cancelButtonAction:(UIBarButtonItem*) sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
