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
        NSArray * components = [self parseLine:line];
        YahooStockValue * stockValue = [[YahooStockValue alloc] initWithArray:components];
        [stockValues addObject:stockValue];
    }];
    
    return stockValues;
}

-(NSArray*)parseLine:(NSString*)line
{
    NSMutableArray * allComponents = [NSMutableArray new];
    NSMutableString * currentComponent = [NSMutableString new];
    BOOL inQuotes = NO;
    BOOL lastWasBackslash = NO;
    for (NSInteger i = 0; i < line.length; i++)
    {
        unichar chr = [line characterAtIndex:i];
        if (chr == '"' && !lastWasBackslash) inQuotes = !inQuotes;
        else if (chr == '\\') lastWasBackslash = YES;
        else if (!inQuotes && chr == ',')
        {
            [allComponents addObject:currentComponent];
            currentComponent = [NSMutableString new];
        }
        else
        {
            lastWasBackslash = NO;
            [currentComponent appendFormat:@"%c", chr];
        }
    }
    
    if (currentComponent.length > 0) [allComponents addObject:currentComponent];
    
    return allComponents;
}

@end
