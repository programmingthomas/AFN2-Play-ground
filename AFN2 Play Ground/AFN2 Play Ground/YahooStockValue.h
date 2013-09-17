//
//  YahooStockValue.h
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 17/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YahooStockValue : NSObject

@property NSString * symbol;
@property NSString * name;
@property NSNumber * latestValue;
@property NSNumber * openValue;
@property NSNumber * closeValue;

-(id)initWithArray:(NSArray*)array;

@end
