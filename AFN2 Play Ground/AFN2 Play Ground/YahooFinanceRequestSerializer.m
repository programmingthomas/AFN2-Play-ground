//
//  YahooFinanceRequestSerializer.m
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 17/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "YahooFinanceRequestSerializer.h"

@implementation YahooFinanceRequestSerializer

//This assumes that there is a key with 'symbols' with each symbol you want to request in an array
-(NSURLRequest*)requestBySerializingRequest:(NSURLRequest *)request withParameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error
{
    NSArray * allSymbols = parameters[@"symbols"];
    
    NSDictionary * params = @{@"f": @"nsl1op",
                              @"e": @".csv",
                              @"s": [allSymbols componentsJoinedByString:@","]};
    
    return [super requestBySerializingRequest:request withParameters:params error:error];
}

@end
