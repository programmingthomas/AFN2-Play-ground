//
//  YahooFinanceRequests.h
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 17/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "YahooFinanceRequestSerializer.h"
#import "YahooFinanceResponseSerializer.h"

typedef void(^FetchedSymbols)(NSArray*symbols);

@interface YahooFinanceClient : AFHTTPSessionManager

+(instancetype)client;

-(void)fetchSymbols:(NSArray*)symbols completion:(FetchedSymbols)fetchedSymbolsBlock;

@end
