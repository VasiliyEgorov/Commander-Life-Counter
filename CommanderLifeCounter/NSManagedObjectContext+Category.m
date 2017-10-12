//
//  NSManagedObjectContext+Category.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "NSManagedObjectContext+Category.h"

@implementation NSManagedObjectContext (Category)

- (id) customExecuteFetchRequest:(NSFetchRequest*)request {
    
    NSError *error = nil;
    
    NSArray *objects = [self executeFetchRequest:request error:&error];
    
    return objects;
    
}


- (id) obtainSingleManagedObjectWithEntityName:(NSString*)entityName {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    
    NSError *error = nil;
    if ([self countForFetchRequest:request error:&error] == 1) {
        return [[self executeFetchRequest:request error:&error] lastObject];
    } else {
    return nil;
    }
}


- (NSArray*) obtainArrayOfManagedObjectsWithEntityName:(NSString*)entityName andPredicate:(NSPredicate*)predicate {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    NSError *error = nil;
    return [self executeFetchRequest:request error:&error];
}

@end
