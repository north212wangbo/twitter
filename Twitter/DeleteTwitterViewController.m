//
//  DeleteTwitterViewController.m
//  Twitter
//
//  Created by Bo Wang on 3/10/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "DeleteTwitterViewController.h"
#import "TwitterTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Tweets.h"

@interface DeleteTwitterViewController () <UIAlertViewDelegate>

@end

@implementation DeleteTwitterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self.tweetContent layer] setBorderWidth:1.0];
    [[self.tweetContent layer] setBorderColor:[[UIColor blackColor] CGColor]];
    
    if (self.tweet != nil) {
        self.handle.text = self.tweet.handle;
        self.tweetContent.text = self.tweet.tweet;
    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deleteTweet:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication" message:@"Enter your WSUID" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.tag = 0;

    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.keyboardAppearance = UIKeyboardAppearanceAlert;
    [alert show];
}

-(void)isDeleted { //perform deletion, check return value, if succeed show "deleteSucceed", else show "authFailed"
    TwitterTableViewController  *tableViewController = [[TwitterTableViewController alloc] init];
    //static NSString *tweetDelCGI = @"http://ezekiel.vancouver.wsu.edu/~wayne/cgi-bin/del-tweet.cgi";
    static NSString *tweetDelCGI = @"http://ezekiel.vancouver.wsu.edu/~cs458/cgi-bin/del-tweet.cgi";
    NSString *tweetID = [NSString stringWithFormat:@"%d",self.tweet.tweetId];
    NSString *encodedTweetID = [tweetID stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedWSUID = [self.wsuid stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *query = [NSString stringWithFormat:@"%@?id=%@&wsuid=%@",tweetDelCGI, encodedTweetID, encodedWSUID];
    NSLog(@"%@",query);
    NSURL *url = [NSURL URLWithString:query];
    [tableViewController delTweet:url];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            self.wsuid = [alertView textFieldAtIndex:0].text;
            [self isDeleted];
        } else {
            NSLog(@"canceled");
        }
    } else {
        NSLog(@"alert view from TwitterTableViewController");
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}





@end
