//
//  DataManager.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 01.06.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "DataManager.h"
#import "NSManagedObjectContext+Category.h"

@interface DataManager ()

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@end

@implementation DataManager

#pragma mark - Singleton

+ (DataManager*)sharedManager {
    
    static DataManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSaveMainQueueContext:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:_mainQueueContext];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(contextDidSavePrivateQueueContext:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:_privateQueueContext];
    }
    return self;
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
  
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"magicApp"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}


- (void) deleteSearchStringContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSArray *array = [context obtainArrayOfManagedObjectsWithEntityName:@"SearchBarManagedObject" andPredicate:nil];
    for (NSManagedObject *searchString in array) {
        [context deleteObject:searchString];
    }
    [self saveContext];
}

- (NSManagedObjectContext*) privateQueueContext {
    
    if (!_privateQueueContext) {
        _privateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateQueueContext = self.persistentContainer.viewContext;
    }
    return _privateQueueContext;
}

- (NSManagedObjectContext*) mainQueueContext {
    
    if (!_mainQueueContext) {
        _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainQueueContext = self.persistentContainer.viewContext;
    }
    return _mainQueueContext;
}

#pragma mark - Notifications

- (void)contextDidSaveMainQueueContext:(NSNotification*)notification {
    
    [_mainQueueContext performBlock:^{
        [self->_mainQueueContext mergeChangesFromContextDidSaveNotification:notification];
        
    }];
}

- (void)contextDidSavePrivateQueueContext:(NSNotification*)notification {
    
    [_privateQueueContext performBlock:^{
        [self->_privateQueueContext mergeChangesFromContextDidSaveNotification:notification];
        
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
