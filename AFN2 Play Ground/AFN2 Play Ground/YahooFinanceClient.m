//
//  YahooFinanceRequests.m
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 17/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "YahooFinanceClient.h"

@implementation YahooFinanceClient

#pragma mark - Singleton

+(instancetype)client
{
    static YahooFinanceClient * requests = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requests = [[YahooFinanceClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://download.finance.yahoo.com/d/quotes.csv"]];
    });
    return requests;
}

#pragma mark - custom initialization

-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self)
    {
        self.requestSerializer = [YahooFinanceRequestSerializer new];
        self.responseSerializer = [YahooFinanceResponseSerializer new];
    }
    return self;
}

@end
