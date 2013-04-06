//
//  BtceApiHandler.h
//  BTCEBot
//
//  Created by Nikita Kolmogorov on 06.04.13.
//  Copyright (c) 2013 Nikita Kolmogorov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BtceApiHandler : NSObject

@property (nonatomic,strong) NSString *api_key;
@property (nonatomic,strong) NSString *secret_key;

- (NSData *)getResponseFromServerForPost:(NSDictionary *)postDictionary;

- (NSData *)getResponseFromPublicServerUrl:(NSString *)urlString;

@end
