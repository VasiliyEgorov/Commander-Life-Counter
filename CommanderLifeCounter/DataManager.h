//
//  DataManager.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "magicApp+CoreDataModel.h"

@interface DataManager : NSObject


@property (strong, nonatomic) NSManagedObjectContext *privateQueueContext;
@property (strong, nonatomic) NSManagedObjectContext *mainQueueContext;

- (void)saveContext;
- (void)deleteSearchStringContext;
+ (DataManager*)sharedManager;

@end
