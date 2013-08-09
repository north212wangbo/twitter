//
//  TwitterTableViewController.h
//  Twitter
//
//  Created by Bo Wang on 3/7/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterTableViewController : UITableViewController
- (IBAction)fetchTweets:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *fetchButton;
@property (copy,nonatomic) NSString *dateString;

@property (strong) NSMutableData *getTweetsData;
@property (strong) NSMutableData *sendTweetData;
@property (strong) NSMutableData *delTweetData;
@property (strong) NSURLConnection *getTweetsConnection;
@property (strong) NSURLConnection *sendTweetConnection;
@property (strong) NSURLConnection *delTweetConnection;


-(void)addTweet: (NSURL*)url;
-(void)delTweet: (NSURL*)url;


@end
