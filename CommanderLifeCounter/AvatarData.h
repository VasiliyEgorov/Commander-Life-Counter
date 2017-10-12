//
//  AvatarData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 17.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerManagedObject+CoreDataClass.h"
#import "OpponentManagedObject+CoreDataClass.h"
#import "NSManagedObjectContext+Category.h"
#import "DataManager.h"

@interface AvatarData : NSObject


@property (strong, nonatomic) PlayerManagedObject *player;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) OpponentManagedObject *opponent;

- (void) snapshotAvatarImageViewForPlayer:(UIImageView*)avatarImageView andScaleToFrame:(CGRect)frame;
- (void) snapshotAvatarImageViewForOpponent:(UIImageView*)avatarImageView andScaleToFrame:(CGRect)frame;
- (void) placePhoto:(UIImage*)photo forAvatarImageView:(UIImageView*)avatarImageView success:(void(^)(UIImage *editedPhoto)) success;
- (void) makeAvatarForPlayerFromName:(NSString*)name forAvatarImageViewFrame:(CGRect)frame;
- (void) makeAvatarForOpponentFromName:(NSString*)name forAvatarImageViewFrame:(CGRect)frame;

@end
