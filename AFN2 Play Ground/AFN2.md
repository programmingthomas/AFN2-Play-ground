Working with AFNetworking 2

This week [Mattt Thompson announced](http://nshipster.com/afnetworking-2/) [AFNetworking 2.0](https://github.com/AFNetworking/AFNetworking/tree/2.0) and for the past couple of days I've been playing around with it (along with a few techniques from [objc.io](http://obcj.io)) to build a simple demo app that showcases some of the new features of AFNetworking. The source for the app discussed in this post is available [on my GitHub profile](https://github.com/programmingthomas/AFN2-Play-ground). To compile the code in this blog post you will need Xcode 5 and iOS 7.

##Getting started
With [CocoaPods](http://cocoapods.org) it was really easy to set the project up, however slightly different from the original AFNetworking. Here is my Podfile:

	platform :ios, '7.0'
	pod "AFNetworking", "2.0.0-RC3"
	pod "AFNetworking/UIKit+AFNetworking", "2.0.0-RC3"

The UIKit extensions for AFNetworking previously only extended UIImageView, however this has now been greatly expanded for other UIViews so is now a separate submodule in CocoaPods. Simply run 'pod install' and open up your Xcode Workspace (not the project) to get started.

##Serializers
I really liked the way that AFNetworking previously handled the serialization of data, however this pattern has now been made more generic so that you can easily write your serializers for requests and responses. One example of this might be if you wished to use an alternative to the standard Cocoa JSON and XML parsers.

In my example app I've written a simple serializer that subclasses AFJSONSerializer to serialize an array from the JSON response from reddit:

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

The great thing about writing a custom serializer is that it is highly reusable - it isn't going to take much work in this example to check whether the response was acutally for comments instead of posts, so it can simply return another array of objects. I've also written a simple class for storing post data:

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

As noted in the comment above, if you do not wish to have properties for all of the possible API keys it makes sense to write a custom setValue:forKey: function to only use the keys you want. This is especially sensible if in the future new keys are added to the API as otherwise your app will crash with an NSUndefinedKeyException.

Then, using the [light view controller pattern described in objc.io #1](http://www.objc.io/issue-1/lighter-view-controllers.html), it is really easy to set up a data source for the app:

	- (void)viewDidLoad
	{
	    [super viewDidLoad];
	    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://reddit.com/.json"]];
	    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	    operation.responseSerializer = [RedditResponseSerializer serializer];
	    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
	        NSArray * allPosts = (NSArray*)responseObject;
	        [self configureDataSource:allPosts];
	    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
	        NSLog(@"%@", error.localizedDescription);
	    }];
	    [operation start];
	}
	
	-(void)configureDataSource:(NSArray*)posts
	{
	    self.dataSource = [[ArrayDataSource alloc] initWithItems:posts cellIdentifier:@"redditPostCell" configureCellBlock:^(id cell, id item) {
	        RedditPost * post = (RedditPost*)item;
	        UITableViewCell * postCell = (UITableViewCell*)cell;
	        postCell.textLabel.text = post.title;
	        postCell.detailTextLabel.text = [NSString stringWithFormat:@"%d points \u2022 /r/%@ \u2022 /u/%@", post.score.integerValue, post.subreddit, post.username];
        
	    }];
	    self.tableView.dataSource = self.dataSource;
	    [self.tableView reloadData];
	}

In this example I've simply requested the JSON for the front page of reddit, used my custom serializer to immediately get an array of the posts and then configured a simple data source for the posts. It is worth noting that you must retain your ArrayDataSource object (i.e. you can't define it in configureDataSource:) because the dataSource property of a UITableView expects only a weak reference to an id<UITableViewDataSource>, so I instead added it as a property.

##More advanced serializer
This example is similiar to the last, however adopts a few new features:

* Use a custom AFHTTPSessionManager which makes it easy to perform custom requests. In this example I'll show a simple way to get stock market quotes from Yahoo Finance
* Use a custom request serializer to set up the URL request based on an array of stock symbols
* Use a custom response serializer and YahooStockValue object to parse the CSV data from Yahoo
* Return the data to the main view controller so it can be displayed in a list

**Custom client**

The current recommendation for clients is that they return a singleton instance as there is little need to recreate the same object. Here is the simple client:

	//YahooFinanceClient.h
	#import <Foundation/Foundation.h>
	#import <AFNetworking.h>
	#import "YahooFinanceRequestSerializer.h"
	#import "YahooFinanceResponseSerializer.h"
	
	typedef void(^FetchedSymbols)(NSArray*symbols);
	
	@interface YahooFinanceClient : AFHTTPSessionManager
	
	+(instancetype)client;
	
	-(void)fetchSymbols:(NSArray*)symbols completion:(FetchedSymbols)fetchedSymbolsBlock;
	
	@end

	//YahooFinanceClient.m
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
	
	#pragma mark - Custom fetching functions
	
	-(void)fetchSymbols:(NSArray *)symbols completion:(FetchedSymbols)fetchedSymbolsBlock
	{
	    [self GET:@"" parameters:@{@"symbols": symbols} success:^(NSURLSessionDataTask *task, id responseObject) {
	        fetchedSymbolsBlock(responseObject);
	    } failure:^(NSURLSessionDataTask *task, NSError *error) {
	        fetchedSymbolsBlock([NSArray new]);
	        NSLog(@"ERROR: %@", error);
	    }];
	}
	
	@end

This sets up a client with a base URL of the API endpoint we will be using. Because this is only fetching data from one endpoint, we will use that one however if we were requesting from Twitter, for example, we would use https://api.twitter.com/1.1/ and then when we wanted to perform a request rather than using a URL of @"" we would use @"statuses/mentions_timeline.json" for example.

