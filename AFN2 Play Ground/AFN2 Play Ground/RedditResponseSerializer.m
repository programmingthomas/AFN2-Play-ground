//
//  RedditResponseSerializer.m
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 16/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "RedditResponseSerializer.h"

@implementation RedditResponseSerializer

-(id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error
{
    NSDictionary * json = [super responseObjectForResponse:response data:data error:error];
    NSMutableArray * posts = [NSMutableArray new];
    NSDictionary * dataObject = json[@"data"];
    if (dataObject != nil)
    {
        NSArray * children = dataObject[@"children"];
        [children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary * postData = [(NSDictionary*)obj objectForKey:@"data"];
            [posts addObject:[RedditPost postWithProperties:postData]];
        }];
    }
    return posts;
}

@end
