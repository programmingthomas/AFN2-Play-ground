//
//  StocksViewController.h
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 17/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "YahooFinanceClient.h"
#import "ArrayDataSource.h"

@interface StocksViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property ArrayDataSource * dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
