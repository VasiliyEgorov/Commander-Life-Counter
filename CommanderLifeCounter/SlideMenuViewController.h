//
//  SlideMenuViewController.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 09.04.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    search,
    rollADie,
    flipACoin,
    resetAllCounters
    
} menu;

@protocol ResetCountersProtocol <NSObject>

- (void) resetCounters;
- (void) jumpToSearch;

@end

@interface SlideMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) id <ResetCountersProtocol> delegate;

- (void) revealToggle:(BOOL) animated;

@end
