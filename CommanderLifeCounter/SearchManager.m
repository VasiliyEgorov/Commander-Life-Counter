//
//  SearchManager.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "SearchManager.h"
#import "SearchData.h"
#import "ServerManager.h"

@interface SearchManager ()

@property (strong, nonatomic) SearchData *data;
@property (strong, nonatomic) ServerManager *server;

@end

@implementation SearchManager

- (SearchData*)data {
    if (!_data) {
        _data = [[SearchData alloc] init];
    }
    return _data;
}

- (ServerManager*)server {
    if (!_server) {
        _server = [[ServerManager alloc] init];
    }
    return _server;
}


- (void) getNewCardsWithHintAndWithName:(NSString*)name
                   onSuccess:(void(^)(NSArray *array)) success
                              onFailure:(void(^)(NSError *error)) failure {
    if (success) {
        
    
    [self.server getNewCardFromAPIWithName:name onSuccess:^(NSArray *array) {
        if (array) {
            [self.data tryToGetCardFromCoreDataWithName:name andCompareWithAPIArray:array onSuccess:^(NSArray *array) {
                if (array) {
                    success(array);
                }
            }];
        }
    
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
            failure(error);
        
    }];
        
    }
}


- (void) getSearchedCardsWithHintAndWithName:(NSString*)name
                                   onSuccess:(void(^)(NSArray *array)) success
                                   onFailure:(void(^)(NSError *error)) failure {
    
    [self.server getNewCardFromAPIWithName:name onSuccess:^(NSArray *array) {
        if (array) {
            [self.data tryToInsertSearchTextWith:name];
            success(array);
        }
    } onFailure:^(NSError *error, NSInteger statusCode) {
        if (error) {
            
            failure(error);
        }
    }];
}

- (void) insertSearchTextWith:(NSString*)searchString {
    
    [self.data tryToInsertSearchTextWith:searchString];
}


- (void) insertIntityWith:(SearchResultsData*)cardDetails {
    
    [[self data] tryToInsertIntityWith:cardDetails];
}


- (void) saveSearchTextToContext:(NSString*)searchText {
    
    [self.data tryToSaveSearchTextToContext:searchText];
}
- (NSString*) insertSearchTextFromContext {
    
    return [self.data tryToInsertSearchTextFromContext];
}


- (void) cancelSearch {
    
    [self.server cancelTask];
}

- (NSArray*) historyArray {
    
    return [self.data tryToReciveHistoryArray];
}


@end
