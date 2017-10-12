//
//  SearchData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "SearchData.h"
#import "CardManagedObject+CoreDataClass.h"
#import "NSManagedObjectContext+Category.h"
#import "NSFetchRequest+Category.h"
#import "CardSearchStringManagedObject+CoreDataClass.h"
#import "SearchBarManagedObject+CoreDataClass.h"
#import "DataManager.h"

@interface SearchData ()

@property (strong, nonatomic) SearchResultsData *card;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation SearchData

- (SearchResultsData*) card {
    if (!_card) {
        _card = [[SearchResultsData alloc] init];
    }
    return _card;
}

- (NSManagedObjectContext*)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [DataManager sharedManager].mainQueueContext;
    }
    return _managedObjectContext;
}

- (void) saveContext {
    
    if ([self.managedObjectContext hasChanges]) {
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }
    
}

#pragma mark - CardSearchViewController

- (void) tryToSaveSearchTextToContext:(NSString*)searchText {
    
    SearchBarManagedObject *search = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"SearchBarManagedObject"];
    
    if (!search) {
        SearchBarManagedObject *search = [[SearchBarManagedObject alloc] initWithContext:self.managedObjectContext];
        search.searchBarText = searchText;
    }
    else {
        
        search.searchBarText = searchText;
    }
    [self saveContext];
}

- (NSString*) tryToInsertSearchTextFromContext {
    
    SearchBarManagedObject *search = [self.managedObjectContext obtainSingleManagedObjectWithEntityName:@"SearchBarManagedObject"];
    
    if (!search) {
        return nil;
    }
    else {
        
        return search.searchBarText;
    }
}

- (void) tryToInsertSearchTextWith:(NSString*)searchString {
    NSFetchRequest *request = [NSFetchRequest fetchRequestForEntityName:@"CardSearchStringManagedObject"
                                                           andPredicate:[NSPredicate predicateWithFormat:
                                                                         @"searchText MATCHES[c] %@", searchString]];
    if (![self.managedObjectContext countForFetchRequest:request error:nil]) {
        [self insertSearchTextWith:searchString];
    }
    else {
        NSArray *array = [self.managedObjectContext customExecuteFetchRequest:request];
        
        CardSearchStringManagedObject *searchStr = [array firstObject];
        searchStr.timestamp = [NSDate date];
        [self saveContext];
    }
    
}


- (void) insertSearchTextWith:(NSString*)searchString {
    
    CardSearchStringManagedObject *searchText = [[CardSearchStringManagedObject alloc] initWithContext:self.managedObjectContext];
    searchText.searchText = searchString;
    searchText.timestamp = [NSDate date];
    [self saveContext];
}

- (void) tryToGetCardFromCoreDataWithName:(NSString*)name
                   andCompareWithAPIArray:(NSArray*)apiArray
                                onSuccess:(void(^)(NSArray *array)) success {
    
    
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestForEntityName:@"CardManagedObject"
                                                           andPredicate:[NSPredicate predicateWithFormat
                                                                         :@"cardName BEGINSWITH[c] %@", name]];
    
    if ([self.managedObjectContext countForFetchRequest:request error:nil]) {
        
        NSArray *managedObjectsArray = [self.managedObjectContext customExecuteFetchRequest:request];
        
        success([[self card] compareAndFilter:managedObjectsArray withObjectFromAPI:apiArray]);
    }
    else {
        success(apiArray);
    }
    
}

- (void) tryToInsertIntityWith:(SearchResultsData*)cardDetails {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestForEntityName:@"CardManagedObject"
                                                           andPredicate:[NSPredicate predicateWithFormat:
                                                                         @"cardName MATCHES[c] %@", cardDetails.cardName]];
    if (![self.managedObjectContext countForFetchRequest:request error:nil]) {
        [self insertEntityWithCard:cardDetails];
    }
    else {
        NSArray *array = [self.managedObjectContext customExecuteFetchRequest:request];
        
        CardManagedObject *cardObject = [array firstObject];
        cardObject.timestamp = [NSDate date];
        [self saveContext];
    }
}


- (void) insertEntityWithCard:(SearchResultsData*)cardDetails {
    
    CardManagedObject *newCard = [[CardManagedObject alloc] initWithContext:self.managedObjectContext];
    
    newCard.cardName = cardDetails.cardName;
    newCard.rarity = cardDetails.rarity;
    newCard.imageUrl = cardDetails.urlString;
    newCard.setName = cardDetails.setName;
    newCard.cardText = cardDetails.text;
    newCard.legalitiesString = cardDetails.legalitiesString;
    newCard.type = cardDetails.type;
    newCard.timestamp = [NSDate date];
    newCard.cardPower = cardDetails.cardPower;
    newCard.cardToughness = cardDetails.cardToughness;
    newCard.cardColorIdentity = cardDetails.cardColorIdentity;
    newCard.cmc = (int)cardDetails.cmc;
   
    [self saveContext];
    
}

- (NSArray*) tryToReciveHistoryArray {
    
    NSFetchRequest *requestCard = [NSFetchRequest fetchRequestForEntityName:@"CardManagedObject" andPredicate:nil];
    NSFetchRequest *requestCardSearchString = [NSFetchRequest fetchRequestForEntityName:@"CardSearchStringManagedObject" andPredicate:nil];
    
    if ([self.managedObjectContext countForFetchRequest:requestCard error:nil] || [self.managedObjectContext countForFetchRequest:requestCardSearchString error:nil]) {
        
        NSArray *cardArray = [self.managedObjectContext customExecuteFetchRequest:requestCard];
        cardArray = [self.card cardHistoryFromArray:cardArray];
        
        NSArray *cardSearchStringArray = [self.managedObjectContext customExecuteFetchRequest:requestCardSearchString];
        cardSearchStringArray = [self.card cardSearchStringHistoryFromArray:cardSearchStringArray];
        
        NSMutableArray *historyArray = [NSMutableArray array];
        [historyArray addObjectsFromArray:cardArray];
        [historyArray addObjectsFromArray:cardSearchStringArray];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
        NSArray *sortedHistoryArray = [historyArray sortedArrayUsingDescriptors:@[descriptor]];
        
        if ([sortedHistoryArray count] > 99) {
            sortedHistoryArray = [self cleanHistoryArray:sortedHistoryArray];
        }
        return sortedHistoryArray;
    }
    
    else {
        return nil;
    }
   
}

- (id) cleanHistoryArray:(NSArray*)historyArray {
    
    NSArray *cleanedArray = [historyArray subarrayWithRange:NSMakeRange(0, 99)];
    
    return cleanedArray;
    
}

@end
