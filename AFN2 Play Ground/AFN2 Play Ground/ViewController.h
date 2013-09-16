//
//  ViewController.h
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 16/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <AFNetworking/AFImageRequestOperation.h>
#import "ArrayDataSource.h"
#import "RedditPostCell.h"
#import "RedditPost.h"
#import "RedditResponseSerializer.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property ArrayDataSource * dataSource;;

@property NSCache * imageCache;

@end
