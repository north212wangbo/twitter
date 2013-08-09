//
//  EditTwitterViewController.h
//  Twitter
//
//  Created by Bo Wang on 3/10/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTwitterViewController : UIViewController <UITextViewDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UITextField *handle;
@property (weak, nonatomic) IBOutlet UITextField *wsuid;
@property (weak, nonatomic) IBOutlet UITextView *tweetContent;
@property (weak, nonatomic) IBOutlet UILabel *charCount;


- (IBAction)addTweet:(id)sender;

@end
