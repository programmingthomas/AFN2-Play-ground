//
//  RedditPost.h
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 16/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "AFURLResponseSerialization.h"

@interface RedditPost : AFJSONResponseSerializer

@property NSString * title;
@property NSString * subreddit;
@property NSString * username;
@property NSString * thumbnail;
@property NSString * url;

@property NSNumber * ups;
@property NSNumber * downs;
@property NSNumber * score;

+(id)postWithProperties:(NSDictionary*)properties;
-(id)initWithProperties:(NSDictionary*)properties;


@end
