//
//  CardData.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardManagedObject+CoreDataClass.h"
#import "CardSearchStringManagedObject+CoreDataClass.h"

@interface SearchResultsData : NSObject

@property (strong, nonatomic) NSString *cardName;
@property (strong, nonatomic) NSString *rarity;
@property (strong, nonatomic) NSString *urlString;
@property (strong, nonatomic) NSString *setName;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSArray *legalities;
@property (strong, nonatomic) NSString *legalitiesString;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSDate *timestamp;
@property (strong, nonatomic) UIImage *placeHolder;
@property (assign, nonatomic) BOOL isntCard;
@property (strong, nonatomic) NSString *cardPower;
@property (strong, nonatomic) NSString *cardToughness;
@property (strong, nonatomic) NSArray *cardColorIdentityArray;
@property (strong, nonatomic) NSString *cardColorIdentity;
@property (assign, nonatomic) NSInteger cmc;

- (id) initWithAPIData:(NSDictionary*) responseObject;
- (id) initWithCoreData:(NSManagedObject*) card;
- (id) compareAndFilter:(NSArray*)fetchedObjects withObjectFromAPI:(NSArray*)objFromAPI;
- (id) cardHistoryFromArray:(NSArray*)fetchedObjects;
- (id) cardSearchStringHistoryFromArray:(NSArray*)fetchedObjects;

@end
