//
//  ServerManager.h
//  CommanderLifeCounter
//
//  Created by Vasiliy Egorov on 16.07.17.
//  Copyright © 2017 VasiliyEgorov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ServerManager : NSObject

- (void) getNewCardFromAPIWithName:(NSString*)name
                          onSuccess:(void(^)(NSArray *array)) success
                          onFailure:(void(^)(NSError *error, NSInteger statusCode)) failure;


- (void) cancelTask;

@end
