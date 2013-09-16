//
//  ViewController.m
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 16/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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
    self.imageCache = [[NSCache alloc] init];
    self.dataSource = [[ArrayDataSource alloc] initWithItems:posts cellIdentifier:@"redditPostCell" configureCellBlock:^(id cell, id item) {
        RedditPost * post = (RedditPost*)item;
        RedditPostCell * postCell = (RedditPostCell*)cell;
        postCell.postTitle.text = post.title;
        postCell.postDetail.text = [NSString stringWithFormat:@"%d points \u2022 /r/%@ \u2022 /u/%@", post.score.integerValue, post.subreddit, post.username];
        if (post.thumbnail.length > 0)
        {
            postCell.imageView.image = nil;
//            if ([self.imageCache objectForKey:post.thumbnail] != nil)
//            {
//                postCell.imageView.image = [self.imageCache objectForKey:post.thumbnail];
//            }
            [postCell.imageView setImageWithURL:[NSURL URLWithString:post.thumbnail]];
        }
        
    }];
    self.tableView.dataSource = self.dataSource;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
