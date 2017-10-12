//
//  NSFetchRequest+Category.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest (Category)

+ (NSFetchRequest*) fetchRequestForEntityName:(NSString*)entityName
                                 andPredicate:(NSPredicate*)predicate;

@end
