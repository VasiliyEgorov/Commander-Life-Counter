//
//  SearchManager.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchResultsData.h"

@interface SearchManager : NSObject

- (void) getNewCardsWithHintAndWithName:(NSString*)name
                              onSuccess:(void(^)(NSArray *array)) success
                              onFailure:(void(^)(NSError *error)) failure;
- (void) getSearchedCardsWithHintAndWithName:(NSString*)name
                              onSuccess:(void(^)(NSArray *array)) success
                              onFailure:(void(^)(NSError *error)) failure;

- (void) insertIntityWith:(SearchResultsData*)cardDetails;

- (void) insertSearchTextWith:(NSString*)searchString;

- (void) saveSearchTextToContext:(NSString*)searchText;

- (NSString*) insertSearchTextFromContext;

- (void) cancelSearch;

- (NSArray*) historyArray;

@end
