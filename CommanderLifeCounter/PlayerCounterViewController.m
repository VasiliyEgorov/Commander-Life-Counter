//
//  PlayerCounterViewController.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 04.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "PlayerCounterViewController.h"
#import "DataManager.h"
#import "SWRevealViewController.h"
#import "NSManagedObjectContext+Category.h"
#import "Constants.h"
#import "UIColor+Category.h"
#import "CustomCountersTextField.h"

@interface PlayerCounterViewController () <UITextFieldDelegate>

@property (strong, nonatomic) PlayerCounterWithContainerController *containerController;

@end

@implementation PlayerCounterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tableViewSettings];
    [self initRightSwipes];
    [self initLeftSwipes];
    [self initObjects];
    [self makePlayerNameTextField];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.containerController = (PlayerCounterWithContainerController*)self.parentViewController;
    [self fetchCounters];
}


#pragma mark - Settings

- (void) initObjects {
    
    if (!self.data) {
        self.data = [[CountersData alloc] init];

        if (self.data.player) {
            [self fetchCounters];
        }
    }
   
}

- (void) tableViewSettings {
    
    self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tabBarController.tabBar setHidden:YES];
    
   }



- (void) makePlayerNameTextField {
    
    self.playerNameTxt = [[UITextField alloc] init];
    self.playerNameTxt.delegate = self;
    [self.playerNameTxt addTarget:self action:@selector(playerNameAction:) forControlEvents:UIControlEventEditingChanged];
    self.playerNameTxt.backgroundColor = [UIColor clearColor];
    self.playerNameTxt.textColor = [UIColor color_150withAlpha:1];
    self.playerNameTxt.tintColor = [UIColor color_150withAlpha:1];
    self.playerNameTxt.textAlignment = NSTextAlignmentCenter;
   
    float h = [UIScreen mainScreen].bounds.size.height;
    
    float border = 1;
    float height = 0;
    float width = 0;
    float originX = [UIScreen mainScreen].bounds.size.width / 20;
    float originY = 0;
    
    if (h == IPHONE_5) {
        
        height = 45;
        width = 170;
        originY = AVATAR_HEIGHT_IPHONE_5 - height - border * 3;
    }
    if (h == IPHONE_6_7) {
        
        height = 55;
        width = 200;
        originY = AVATAR_HEIGHT_IPHONE_6_7 - height - border * 3;
    }
    if (h == IPHONE_6_7_PLUS) {
        
        height = 60;
        width = 215;
        originY = AVATAR_HEIGHT_IPHONE_6_7_PLUS - height - border * 3;
    }
    if (h == IPHONE_X) {
        
        height = 55;
        width = 200;
        originY = AVATAR_HEIGHT_IPHONE_6_7_PLUS - height - border * 3;
    }
    self.playerNameTxt.frame = CGRectMake(originX, originY, width, height);
    self.playerNameTxt.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:self.playerNameTxt.frame.size.height * 2.5/3];
    self.playerNameTxt.minimumFontSize = 7;
    self.playerNameTxt.spellCheckingType = UITextSpellCheckingTypeNo;
    self.playerNameTxt.autocorrectionType = UITextAutocorrectionTypeNo;
    
    CALayer* layer = [self.playerNameTxt layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
    bottomBorder.borderWidth = border;
    bottomBorder.frame = CGRectMake(0, layer.frame.size.height, layer.frame.size.width, border);
    bottomBorder.backgroundColor = [UIColor color_150withAlpha:1].CGColor;
    
    [layer addSublayer:bottomBorder];

    self.playerNameTxt.attributedPlaceholder = [self resizePlaceholderTextToFit:self.playerNameTxt];
   
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
    [cell.contentView addSubview:self.playerNameTxt];
}

- (NSAttributedString*) resizePlaceholderTextToFit:(UITextField*)textField {
    
    NSString *placeholderText = @"Player name";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:placeholderText];
    
    [str addAttributes:@{ NSForegroundColorAttributeName :[UIColor color_150withAlpha:0.3],
                          NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:textField.frame.size.height] } range:NSMakeRange(0, [str length])];
    NSAttributedString *placeholder = str;
    
    UIFont *font = [placeholder attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    
    CGFloat fontSize = font.pointSize;
    
    NSMutableAttributedString *mutPlaceholder = placeholder.mutableCopy;
    
    CGSize boundsSize = [textField placeholderRectForBounds:textField.bounds].size;
    
    CGSize abstractSize = CGSizeMake(FLT_MAX, boundsSize.height);
    CGFloat maxWidth = boundsSize.width;
    CGFloat fontDecrement = 3;
    
    BOOL fits = NO;
    
    while (!fits && fontSize >= textField.minimumFontSize) {
        CGRect measuredRect = [mutPlaceholder boundingRectWithSize:abstractSize options:0 context:nil];
        if (!(fits = measuredRect.size.width <= maxWidth)) {
            
            fontSize -= fontDecrement;
            font = [font fontWithSize:fontSize];
            [mutPlaceholder addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, mutPlaceholder.string.length)];
        }
    }
    
    return mutPlaceholder;
}

- (void) resizeTextToFit:(UITextField*)textField {
    
    UITextField *temp = textField;
    temp.adjustsFontSizeToFitWidth = YES;
    textField.font = temp.font;
 
}

- (NSManagedObjectContext*)managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [DataManager sharedManager].mainQueueContext;
    }
    return  _managedObjectContext;
}



#pragma mark - Swipes

- (void) initRightSwipes {
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe)];
    
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    
}

- (void) initLeftSwipes {
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe)];
    
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    [self.view addGestureRecognizer:leftSwipe];
    
}

- (void) handleRightSwipe {
    
  if (self.revealViewController.frontViewPosition != FrontViewPositionRight) {
      
      self.tabBarController.selectedIndex = 1;
  }
}

- (void) handleLeftSwipe {
    
   if (self.revealViewController.frontViewPosition != FrontViewPositionRight) {
       
       self.tabBarController.selectedIndex = 2;
   }
}

#pragma mark - PlayerCounterProtocol

- (void) updateCounters {
    
    [self.tableView beginUpdates];
    [self fetchCounters];
    [self.tableView endUpdates];
}

#pragma mark - TableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

   CGFloat spacingHeight = 4.f;
    
    return spacingHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    CGFloat footerHeight = 0;
    
    return footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *spacingView = [UIView new];
    [spacingView setBackgroundColor:[UIColor clearColor]];
    return spacingView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return [self.data rowHeight:indexPath.section];
}


#pragma mark - Actions


- (IBAction)countersButtonsAction:(UIButton *)sender {
   
    [self.data countPlayerCountersWithTag:sender.tag sender:self];

    [self.tableView beginUpdates];
    [self fetchCounters];
    [self.tableView endUpdates];
}

- (void)playerNameAction:(UITextField *)textField {
    
    if ([textField.text isEqualToString:EMPTY]) {
        textField.attributedPlaceholder = [self resizePlaceholderTextToFit:self.playerNameTxt];
    }
    else {
        [self resizeTextToFit:textField];
    }
}


- (IBAction)counterNameTxtAction:(UITextField*)sender {
   
    [self.data counterNameTxt:self.thirdCounterNameTxt.text fourthCounterTxt:self.fourthCounterNameTxt.text];
    
  
}

- (IBAction)addThirdRowAction:(UIButton *)sender {

    [self.data updateThirdRowContent];
  
    [self.tableView beginUpdates];
    [self fetchCounters];
    [self.tableView endUpdates];
    
}

- (IBAction)addFourthRowAction:(UIButton *)sender {
    
    [self.data updateFourthRowContent];
  
    [self.tableView beginUpdates];
    [self fetchCounters];
    [self.tableView endUpdates];
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];

    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isMemberOfClass:[CustomCountersTextField class]]) {
        return;
    }
    CountersIndexManagedObject *indexObject = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"CountersIndexManagedObject"];
    OpponentManagedObject *opponent = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"OpponentManagedObject"];
    PlayerManagedObject *player = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"PlayerManagedObject"];
    
    if (indexObject.index == 0) {
        NSLog(@"%@ %@", player.name, textField.text);
        if (player.avatar == nil && ![textField.text isEqualToString:player.name]) {
            [self.containerController.avatarData makeAvatarForPlayerFromName:textField.text forAvatarImageViewFrame:self.containerController.avatarImageViewFrame];
        }
    }
    else {
     
        if (opponent.avatar == nil && ![textField.text isEqualToString:opponent.name]) {
            [self.containerController.avatarData makeAvatarForOpponentFromName:textField.text forAvatarImageViewFrame:self.containerController.avatarImageViewFrame];
        }
    }
    [self.data playerNameTxt:self.playerNameTxt.text];
    [self fetchCounters];
    
    
}

#pragma mark - Fetch/ManagedObjectContext

- (void) fetchCounters {
    
    CountersIndexManagedObject *indexObject = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"CountersIndexManagedObject"];
    OpponentManagedObject *opponent = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"OpponentManagedObject"];
    PlayerManagedObject *player = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"PlayerManagedObject"];

    self.counterIndex = indexObject.index;
    
    self.playerNameTxt.adjustsFontSizeToFitWidth = NO;
    
    if (indexObject.index == 0) {
        
        self.playerNameTxt.text = player.name;
        
        if ([self.playerNameTxt.text isEqualToString:EMPTY]) {
            self.playerNameTxt.attributedPlaceholder = [self resizePlaceholderTextToFit:self.playerNameTxt];
        }
        else {
            [self resizeTextToFit:self.playerNameTxt];
        }
        self.firstLabel.text = [NSString stringWithFormat:@"%d", player.counters.firstCounter];
        self.secondLabel.text = [NSString stringWithFormat:@"%d", player.counters.secondCounter];
        self.thirdLabel.text = [NSString stringWithFormat:@"%d", player.counters.thirdCounter];
        self.fourthLabel.text = [NSString stringWithFormat:@"%d", player.counters.fourthCounter];
        
        [self.addThirdRow setBackgroundImage:[UIImage imageWithData:player.counters.interface.addThirdRowButtonImage] forState:UIControlStateNormal];
        [self.addFourthRow setBackgroundImage:[UIImage imageWithData:player.counters.interface.addFourthRowButtonImage] forState:UIControlStateNormal];
        self.thirdCounterNameTxt.text = player.thirdCounterName;
        self.fourthCounterNameTxt.text = player.fourthCounterName;
        
        if (player.avatar != nil) {
            [self.containerController.addAvatarImageView removeFromSuperview];
            self.containerController.avatarImageView.image = [UIImage imageWithData:player.avatar];
            
        } else {
                
                 self.containerController.avatarImageView.image = [UIImage imageWithData:player.avatarPlaceholder];
            if (player.avatarPlaceholder != nil) {
                [self.containerController.addAvatarImageView removeFromSuperview];
            }
        }
    }
    
     else {
        
         self.playerNameTxt.text = opponent.name;
         if ([self.playerNameTxt.text isEqualToString:EMPTY]) {
             self.playerNameTxt.attributedPlaceholder = [self resizePlaceholderTextToFit:self.playerNameTxt];
         }
         else {
             [self resizeTextToFit:self.playerNameTxt];
         }
     
         self.firstLabel.text = [NSString stringWithFormat:@"%d", opponent.counter.firstCounter];
         self.secondLabel.text = [NSString stringWithFormat:@"%d", opponent.counter.secondCounter];
         self.thirdLabel.text = [NSString stringWithFormat:@"%d", opponent.counter.thirdCounter];
         self.fourthLabel.text = [NSString stringWithFormat:@"%d", opponent.counter.fourthCounter];
         [self.addThirdRow setBackgroundImage:[UIImage imageWithData:opponent.counter.interface.addThirdRowButtonImage] forState:UIControlStateNormal];
         [self.addFourthRow setBackgroundImage:[UIImage imageWithData:opponent.counter.interface.addFourthRowButtonImage] forState:UIControlStateNormal];
         self.thirdCounterNameTxt.text = opponent.thirdCounterName;
         self.fourthCounterNameTxt.text = opponent.fourthCounterName;
         
         if (opponent.avatar != nil) {
             [self.containerController.addAvatarImageView removeFromSuperview];
             self.containerController.avatarImageView.image = [UIImage imageWithData:opponent.avatar];
   
         } else {
            
                 self.containerController.avatarImageView.image = [UIImage imageWithData:opponent.avatarPlaceholder];
             if (opponent.avatarPlaceholder != nil) {
                 [self.containerController.addAvatarImageView removeFromSuperview];
             }
   
         }
        
     }
}
    
    
    
- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
