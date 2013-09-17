//
//  YahooFinanceResponseSerializer.m
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 17/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "YahooFinanceResponseSerializer.h"

@implementation YahooFinanceResponseSerializer

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSString * strData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSMutableArray * stockValues = [NSMutableArray new];
    
    [strData enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        [stockValues addObject:[[YahooStockValue alloc] initWithString:line]];
    }];
    
    return stockValues;
}

@end
