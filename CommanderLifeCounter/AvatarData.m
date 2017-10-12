//
//  AvatarData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 17.08.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "AvatarData.h"
#import "UIImage+Category.h"
#import "RandomAvatarData.h"

@interface AvatarData ()

@property (strong, nonatomic) RandomAvatarData *randomData;

@end

@implementation AvatarData

- (RandomAvatarData*) randomData {
    
    if (!_randomData) {
        _randomData = [[RandomAvatarData alloc] init];
    }
    return _randomData;
}

- (NSManagedObjectContext*) managedObjectContext {
    
    if (!_managedObjectContext) {
        _managedObjectContext = [DataManager sharedManager].mainQueueContext;
    }
    return  _managedObjectContext;
}

- (PlayerManagedObject*) player {
    
    if (!_player) {
        _player = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"PlayerManagedObject"];
    }
    
    return _player;
}

- (OpponentManagedObject*) opponent {
    
    if (!_opponent) {
        _opponent = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"OpponentManagedObject"];
    }
    
    return _opponent;
}

#pragma mark - Context methods



- (void) saveContext {
    
    if ([self.managedObjectContext hasChanges]) {
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }
    
}

#pragma mark - Avatar / Edit avatar methods



- (void) placePhoto:(UIImage*)photo forAvatarImageView:(UIImageView*)avatarImageView success:(void(^)(UIImage *editedPhoto)) success {
    
     UIImage *scaledImage = [UIImage scaleImage:photo toFrame:avatarImageView.frame];
     UIImage *croppedImage = [UIImage cropImage:scaledImage toRect:avatarImageView.frame];

    if (success) {
        success(croppedImage);
    }
}

- (void) snapshotAvatarImageViewForPlayer:(UIImageView*)avatarImageView andScaleToFrame:(CGRect)frame {
    
    UIImage *merdegedImage = [UIImage mergeViewAndItsLayer:avatarImageView];
    UIImage *scaledImage = [UIImage scaleImage:merdegedImage toFrame:frame];
    
    self.player.avatar = [UIImage convertImageToData:scaledImage];
    
    [self saveContext];
    
}

- (void) snapshotAvatarImageViewForOpponent:(UIImageView*)avatarImageView andScaleToFrame:(CGRect)frame {
    
    UIImage *merdegedImage = [UIImage mergeViewAndItsLayer:avatarImageView];
    UIImage *scaledImage = [UIImage scaleImage:merdegedImage toFrame:frame];
    
    self.opponent.avatar = [UIImage convertImageToData:scaledImage];
    
    [self saveContext];
    
}

- (void) makeAvatarForPlayerFromName:(NSString*)name forAvatarImageViewFrame:(CGRect)frame {
    
    UIImage *avatarImage = [self.randomData selectAvatarForName:name scaleImageTo:frame];
    
    self.player.avatarPlaceholder = [UIImage convertImageToData:avatarImage];
    
    [self saveContext];
}

- (void) makeAvatarForOpponentFromName:(NSString*)name forAvatarImageViewFrame:(CGRect)frame {
   
    UIImage *avatarImage = [self.randomData selectAvatarForName:name scaleImageTo:frame];
    
    self.opponent.avatarPlaceholder = [UIImage convertImageToData:avatarImage];
    
    [self saveContext];
}

@end
