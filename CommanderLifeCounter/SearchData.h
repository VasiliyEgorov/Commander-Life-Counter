//
//  SearchData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResultsData.h"


@interface SearchData : NSObject

- (void)saveContext;

- (void) tryToGetCardFromCoreDataWithName:(NSString*)name
                   andCompareWithAPIArray:(NSArray*)apiArray
                                onSuccess:(void(^)(NSArray *array)) success;

- (void) tryToInsertIntityWith:(SearchResultsData*)cardDetails;

- (void) tryToSaveSearchTextToContext:(NSString*)searchText;

- (NSString*) tryToInsertSearchTextFromContext;

- (NSArray*) tryToReciveHistoryArray;

- (void) tryToInsertSearchTextWith:(NSString*)searchString;

@end
