//
//  NSFetchRequest+Category.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "NSFetchRequest+Category.h"

@implementation NSFetchRequest (Category)

+ (NSFetchRequest*) fetchRequestForEntityName:(NSString*)entityName
                                 andPredicate:(NSPredicate*)predicate {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    return request;
}

@end
