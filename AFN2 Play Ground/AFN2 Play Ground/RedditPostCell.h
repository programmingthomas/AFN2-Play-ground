//
//  RedditPostCell.h
//  AFN2 Play Ground
//
//  Created by Thomas Denney on 16/09/2013.
//  Copyright (c) 2013 Programming Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedditPostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UILabel *postDetail;

@end
