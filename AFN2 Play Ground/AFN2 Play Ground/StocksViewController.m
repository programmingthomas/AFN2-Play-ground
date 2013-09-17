//
//  StocksViewController.m
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 17/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import "StocksViewController.h"

@interface StocksViewController ()

@end

@implementation StocksViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchByStockSymbol:textField.text];
    return NO;
}

-(void)searchByStockSymbol:(NSString*)symbol
{
    YahooFinanceClient * client = [YahooFinanceClient client];
    [client fetchSymbols:[[symbol uppercaseString] componentsSeparatedByString:@" "] completion:^(NSArray *symbols) {
        self.dataSource = [[ArrayDataSource alloc] initWithItems:symbols cellIdentifier:@"stockCell" configureCellBlock:^(id cell, id item) {
            UITableViewCell * tCell = (UITableViewCell*)cell;
            YahooStockValue * stockValue = (YahooStockValue*)item;
            tCell.textLabel.text = stockValue.name;
            tCell.detailTextLabel.text = stockValue.latestValue.stringValue;
        }];
        self.tableView.dataSource = self.dataSource;
        [self.tableView reloadData];
    }];
}

@end
