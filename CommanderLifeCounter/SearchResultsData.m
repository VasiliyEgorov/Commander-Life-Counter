//
//  CardData.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "SearchResultsData.h"
#import "Constants.h"

@implementation SearchResultsData

- (id) initWithAPIData:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.cardName = [responseObject objectForKey:@"name"];
        self.type = [responseObject objectForKey:@"type"];
        self.setName = [responseObject objectForKey:@"setName"];
        self.rarity = [responseObject objectForKey:@"rarity"];
        self.text = [responseObject objectForKey:@"text"];
        self.legalities = [responseObject objectForKey:@"legalities"];
        self.legalitiesString = [self getLegalitiesFromArray:self.legalities];
        self.placeHolder = [UIImage imageNamed:@"searchForCardCell.png"];
        self.urlString = [responseObject objectForKey:@"imageUrl"];
        self.cardPower = [self checkInformationAvailability:[responseObject objectForKey:@"power"]];
        self.cardToughness = [self checkInformationAvailability:[responseObject objectForKey:@"toughness"]];
        self.cardColorIdentityArray = [responseObject objectForKey:@"colorIdentity"];
        self.cardColorIdentity = [self getCardColorsFromArray:self.cardColorIdentityArray];
        self.cmc = [[responseObject objectForKey:@"cmc"] integerValue];
    }
    return self;
}

- (id) initWithCoreData:(NSManagedObject*) card {
    
    self = [super init];
    if (self) {
        
        self.cardName = [card valueForKey:@"cardName"];
        self.type = [card valueForKey:@"type"];
        self.setName = [card valueForKey:@"setName"];
        self.rarity = [card valueForKey:@"rarity"];
        self.text = [card valueForKey:@"cardText"];
        self.legalitiesString = [card valueForKey:@"legalitiesString"];
        self.placeHolder = [UIImage imageNamed:@"coredataPlaceholder.png"];
        self.urlString = [card valueForKey:@"imageUrl"];
        self.timestamp = [card valueForKey:@"timestamp"];
        self.cardPower = [card valueForKey:@"cardPower"];
        self.cardToughness = [card valueForKey:@"cardToughness"];
        self.cardColorIdentity = [card valueForKey:@"cardColorIdentity"];
        self.cmc = [[card valueForKey:@"cmc"] integerValue];
    }
    return self;
    
}

- (id) initCardNameWithSearchString:(NSManagedObject*) searchText {

    self = [super init];
    if (self) {
        
        self.cardName = [searchText valueForKey:@"searchText"];
        self.timestamp = [searchText valueForKey:@"timestamp"];
        self.placeHolder = [UIImage imageNamed:@"coredataPlaceholder.png"];
        self.isntCard = YES;
    }
    return self;
}

- (NSString*) getCardColorsFromArray:(NSArray*)array {
    
    NSString *result;
    NSMutableString *colorIdentity = [NSMutableString string];
    
    if (!array) {
        return EMPTY;
    }
    for (NSString *colors in array) {
        
        [colorIdentity appendFormat:@"%@, ", colors];
    }
    NSRange range = [colorIdentity rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        result = [colorIdentity stringByReplacingCharactersInRange:range withString:EMPTY];
    }

    
    return result;
}

- (NSString*) checkInformationAvailability:(NSString*) responseString {
    if (!responseString) {
        return @"None";
    } else {
        return responseString;
    }
}

- (NSString*) getLegalitiesFromArray:(NSArray*) array {
    
    NSString *format;
    NSString *noInfo = @"No information sorry about that";
    NSMutableString *result = [NSMutableString string];
    
    if (!array) {
        return noInfo;
    }
    for (NSDictionary *dic in array) {
        
        format = [dic objectForKey:@"format"];
        
        [result appendFormat:@"%@, ", format];
    }
    
    format = result;
    
    NSRange range = [format rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        format = [format stringByReplacingCharactersInRange:range withString:EMPTY];
    }
    
    return format;
}

- (id) compareAndFilter:(NSArray*)fetchedObjects withObjectFromAPI:(NSArray*)objFromAPI {
    
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *filteredCards = [NSMutableArray array];
    for (NSManagedObject *managedObject in fetchedObjects) {
        NSString *name = [managedObject valueForKey:@"cardName"];
        SearchResultsData *fetchedCard = [[SearchResultsData alloc] initWithCoreData:managedObject];
        [filteredCards addObject:fetchedCard];
        [temp addObject:name];
    }
    for (SearchResultsData *cardAPI in objFromAPI) {
        if ([temp indexOfObject:cardAPI.cardName] == NSNotFound) {
            [filteredCards addObject:cardAPI];
        }
    }
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    NSArray *sortedArray = [filteredCards sortedArrayUsingDescriptors:@[descriptor]];
    
    return sortedArray;
}

- (id) cardHistoryFromArray:(NSArray*)fetchedObjects {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSManagedObject *cardObj in fetchedObjects) {
        SearchResultsData *card = [[SearchResultsData alloc] initWithCoreData:cardObj];
        [array addObject:card];
    }
    
    return array;
}

- (id) cardSearchStringHistoryFromArray:(NSArray*)fetchedObjects {
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSManagedObject *searchStr in fetchedObjects) {
        SearchResultsData *card = [[SearchResultsData alloc] initCardNameWithSearchString:searchStr];
        [array addObject:card];
    }
    return array;
}

@end
