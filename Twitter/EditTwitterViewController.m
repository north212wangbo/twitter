//
//  EditTwitterViewController.m
//  Twitter
//
//  Created by Bo Wang on 3/10/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "EditTwitterViewController.h"
#import "TwitterTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TwitterAppDelegate.h"

@interface EditTwitterViewController () {
    TwitterTableViewController *tableViewController;
}

@end

@implementation EditTwitterViewController

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

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {//Load sotred handle & wsuid information
    [super viewDidAppear:animated];
    TwitterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if ([appDelegate.userinfoArray count] != 0) {
        self.handle.text = [appDelegate.userinfoArray objectAtIndex:0];
        self.wsuid.text = [appDelegate.userinfoArray objectAtIndex:1];
        [self.tweetContent becomeFirstResponder];
    } else {
        [self.handle becomeFirstResponder];
    }
}

- (void)textViewDidChange:(UITextView *)textView { //Count tweet letter
    NSString *subString =[NSString stringWithString:self.tweetContent.text];
    self.charCount.text = [NSString stringWithFormat:@"%d/140",subString.length];    
}

static NSString *makeSafeForURLArgument(NSString *str) {
    NSMutableString *temp = [str mutableCopy];
    [temp replaceOccurrencesOfString:@"?" withString:@"%3F" options:0 range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"=" withString:@"%3D" options:0 range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"&" withString:@"%26" options:0 range:NSMakeRange(0, [temp length])];
    return temp;
}

- (IBAction)addTweet:(id)sender {
    TwitterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    tableViewController = [[TwitterTableViewController alloc] init];
    //static NSString *tweetSendCGI = @"http://ezekiel.vancouver.wsu.edu/~wayne/cgi-bin/add-tweet.cgi";
    static NSString *tweetSendCGI = @"http://ezekiel.vancouver.wsu.edu/~cs458/cgi-bin/add-tweet.cgi";
    NSString *tweet = self.tweetContent.text;
    NSString *encodedTweet = [tweet stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *handle = self.handle.text;
    NSString *encodedHandle = [handle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlEncodedTweet = makeSafeForURLArgument(encodedTweet);
    NSString *urlEncodedHandle = makeSafeForURLArgument(encodedHandle);
    NSString *encodedWSUID = [self.wsuid.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *query = [NSString stringWithFormat:@"%@?handle=%@&wsuid=%@&tweet=%@",tweetSendCGI, urlEncodedHandle, encodedWSUID, urlEncodedTweet];

    [appDelegate.userinfoArray  removeAllObjects];
    [appDelegate.userinfoArray addObject:self.handle.text];
    [appDelegate.userinfoArray addObject:self.wsuid.text];
    
    NSLog(@"%@",query);
    NSURL *url = [NSURL URLWithString:query];
    if (tweet == nil || handle == nil || self.wsuid.text.length != 8) { //a simple validation on the format of tweet
        NSLog(@"invalid tweet");
        return;
    }
    [tableViewController addTweet:url];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


















@end
