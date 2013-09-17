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
    self.dataSource = [[ArrayDataSource alloc] initWithItems:posts cellIdentifier:@"redditPostCell" configureCellBlock:^(id cell, id item) {
        RedditPost * post = (RedditPost*)item;
        UITableViewCell * postCell = (UITableViewCell*)cell;
        postCell.textLabel.text = post.title;
        postCell.detailTextLabel.text = [NSString stringWithFormat:@"%d points \u2022 /r/%@ \u2022 /u/%@", post.score.integerValue, post.subreddit, post.username];
        
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
