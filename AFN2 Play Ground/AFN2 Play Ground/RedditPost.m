//
//  RedditPost.m
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 16/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "RedditPost.h"

@implementation RedditPost

+(id)postWithProperties:(NSDictionary *)properties
{
    return [[self alloc] initWithProperties:properties];
}

-(id)initWithProperties:(NSDictionary *)properties
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:properties];
    }
    return self;
}

//Had to do a custom implementation of this because I didn't want all keys
-(void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"title"]) self.title = value;
    else if ([key isEqualToString:@"subreddit"]) self.subreddit = value;
    else if ([key isEqualToString:@"author"]) self.username = value;
    else if ([key isEqualToString:@"thumbnail"]) self.thumbnail = value;
    else if ([key isEqualToString:@"url"]) self.url = value;
    else if ([key isEqualToString:@"ups"]) self.ups = value;
    else if ([key isEqualToString:@"downs"]) self.downs = value;
    else if ([key isEqualToString:@"score"]) self.score = value;
}

@end
