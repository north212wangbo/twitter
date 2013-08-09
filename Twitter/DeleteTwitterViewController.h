//
//  DeleteTwitterViewController.h
//  Twitter
//
//  Created by Bo Wang on 3/10/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweets;

@interface DeleteTwitterViewController : UIViewController

@property (strong,nonatomic) Tweets *tweet;
@property (weak, nonatomic) IBOutlet UILabel *handle;
@property (weak, nonatomic) NSString *wsuid;
@property (weak, nonatomic) IBOutlet UITextView *tweetContent;
- (IBAction)deleteTweet:(id)sender;

@end
