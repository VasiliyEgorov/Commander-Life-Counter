//
//  ServerManager.m
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "SearchResultsData.h"
#import "UIImageView+AFNetworking.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) NSURLSessionDataTask *task;
@property (strong, nonatomic) NSURL *accessoryURL;

@end

@implementation ServerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.accessoryURL = [NSURL URLWithString:@"https://api.magicthegathering.io/v1/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:self.accessoryURL];
        self.sessionManager.requestSerializer.timeoutInterval = 20;
    }
    return self;
}


- (void) getNewCardFromAPIWithName:(NSString*)name
                          onSuccess:(void(^)(NSArray *array)) success
                          onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure {
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                name, @"name",
                                @(100), @"pageSize",
                                @"legalities", @"legalities",
                                nil];
    
  self.task = [self.sessionManager GET:@"cards"
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
                         
                         
                         NSArray *dictionaryInArray = [responseObject objectForKey:@"cards"];
                         
                         NSPredicate *predicate = [NSPredicate predicateWithFormat:
                                                   @"SELF ['name'] BEGINSWITH[c] %@", name];
                         
                         NSArray *filteredArray = [dictionaryInArray filteredArrayUsingPredicate:predicate];
                         
                         NSMutableArray *objectsArray = [NSMutableArray array];
                         
                         NSMutableArray *resultArray = [NSMutableArray array];
                         
                         NSString *name;
                         
                         for (NSDictionary *dictionary in filteredArray) {
                             
                             name = [dictionary objectForKey:@"name"];
                             if ([objectsArray indexOfObject:name] == NSNotFound){
                                 [objectsArray addObject:name];
                                 SearchResultsData *card = [[SearchResultsData alloc] initWithAPIData:dictionary];
                                 
                                 [resultArray addObject:card];
                             }
                             
                         }
                         
                         if (success) {
                             success(resultArray);
                             [resultArray removeAllObjects];
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        
                            failure(error, 0);
                         
                     }];
}


- (void) cancelTask {
    [self.task cancel];
}



@end
