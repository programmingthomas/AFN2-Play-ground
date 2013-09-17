//
//  YahooStockValue.m
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 17/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "YahooStockValue.h"

@implementation YahooStockValue

-(id)initWithString:(NSString *)data
{
    self = [super init];
    if (self)
    {
        //Messy way of doing this, there are several quicker ways of doing this
        NSMutableArray * allComponents = [NSMutableArray new];
        NSMutableString * currentComponent = [NSMutableString new];
        BOOL inQuotes = NO;
        for (NSInteger i = 0; i < data.length; i++)
        {
            unichar chr = [data characterAtIndex:i];
            if (chr == '"' && ((i == 0) ||  (i > 0 && [data characterAtIndex:i - 1] != '\\'))) inQuotes = !inQuotes;
            else if (!inQuotes && chr == ',')
            {
                [allComponents addObject:currentComponent];
                currentComponent = [NSMutableString new];
            }
            else [currentComponent appendFormat:@"%c", chr];
        }
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        if (currentComponent.length > 0) [allComponents addObject:currentComponent];
        if (allComponents.count >= 1) self.name = allComponents[0];
        if (allComponents.count >= 2) self.symbol = allComponents[1];
        if (allComponents.count >= 3) self.latestValue = [f numberFromString:allComponents[2]];
        if (allComponents.count >= 4) self.openValue = [f numberFromString:allComponents[3]];
        if (allComponents.count >= 5) self.closeValue = [f numberFromString:allComponents[4]];
    }
    return self;
}

@end
