//
//  YahooStockValue.m
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 17/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "YahooStockValue.h"

@implementation YahooStockValue

-(id)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self)
    {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        if (array.count >= 1) self.name = array[0];
        if (array.count >= 2) self.symbol = array[1];
        if (array.count >= 3) self.latestValue = [f numberFromString:array[2]];
        if (array.count >= 4) self.openValue = [f numberFromString:array[3]];
        if (array.count >= 5) self.closeValue = [f numberFromString:array[4]];
    }
    return self;
}

@end
