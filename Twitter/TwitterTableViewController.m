//
//  TwitterTableViewController.m
//  Twitter
//
//  Created by Bo Wang on 3/7/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "TwitterTableViewController.h"
#import "TwitterAppDelegate.h"
#import "Tweets.h"
#import "EditTwitterViewController.h"
#import "DeleteTwitterViewController.h"

@interface TwitterTableViewController () {
    DeleteTwitterViewController *deleteTwitterViewController;
}

@end

@implementation TwitterTableViewController {

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    TwitterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.dateString = appDelegate.refreshDateString;
    NSLog(@"%@",self.dateString);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TwitterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return [appDelegate.tweets count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TwitterAppDelegate *appDelegate = (TwitterAppDelegate *)[[UIApplication sharedApplication] delegate];
    Tweets *tweet = [appDelegate.tweets objectAtIndex:indexPath.row];
    
    NSString *tweetContent = tweet.tweet;
    UIFont *font = [UIFont systemFontOfSize:17];
    CGSize maxSize = CGSizeMake(230, 999.0);
    CGSize size = [tweetContent sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByTruncatingTail];
    return size.height + 20;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    TwitterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Tweets *tweet = [appDelegate.tweets objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)-%@",tweet.handle,tweet.wsuid,tweet.tstamp];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.detailTextLabel.text = tweet.tweet;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"deleteTwitterSegue"]) {
        DeleteTwitterViewController *destinationViewController = (DeleteTwitterViewController *) segue.destinationViewController;
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        TwitterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        destinationViewController.tweet = [appDelegate.tweets objectAtIndex:indexPath.row];
    }
}

#ifdef USING_BACKGROUND_OPERATION

-(void)downloadTweets:(id)dontcare{
    static NSString *getTweetCGI = @"http://ezekiel.vancouver.wsu.edu/~cs458/cgi-bin/get-tweets.cgi";
    //static NSString *getTweetCGI = @"http://ezekiel.vancouver.wsu.edu/~wayne/cgi-bin/get-tweets.cgi";
    
    NSString *encodedDateString = [self.dateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *query = [NSString stringWithFormat:@"%@?date=%@", getTweetCGI, encodedDateString];
    NSURL *url = [NSURL URLWithString:query];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfURL:url];
    TwitterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    for (NSDictionary *dict in array) {
        Tweets *newTweet = [[Tweets alloc] init];
        newTweet.tweetId = [[dict objectForKey:@"id"] integerValue];
        newTweet.isdeleted = [[dict objectForKey:@"isdeleted"] integerValue];
        newTweet.tweet = [dict objectForKey:@"tweet"];
        newTweet.handle = [dict objectForKey:@"handle"];
        newTweet.wsuid = [dict objectForKey:@"wsuid"];
        newTweet.tstamp = [dict objectForKey:@"tstamp"];
        self.dateString = [dict objectForKey:@"tstamp"];
        [appDelegate.tweets addObject: newTweet];
    }
    
    [self performSelectorOnMainThread:@selector(doneDownloadTweets) withObject:nil waitUntilDone:YES];
}

-(void)doneDownloadTweets {
    [self.tableView reloadData];
    self.fetchButton.enabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#endif

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    if(connection == self.getTweetsConnection) {
        [self.getTweetsData setLength:0];
    } else if (connection == self.sendTweetConnection){
        [self.sendTweetData setLength:0];
    } else {
        [self.delTweetData setLength:0];
    }
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
    if(connection == self.getTweetsConnection) {
        [self.getTweetsData appendData:data];
    } else if (connection == self.sendTweetConnection) {
        [self.sendTweetData appendData:data];
        NSDictionary *dict = [NSPropertyListSerialization propertyListFromData:self.sendTweetData mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
        NSInteger isSuccess = [[dict objectForKey:@"success"] integerValue];
        if (isSuccess) {
            NSLog(@"send successfully");
        } else {
            NSLog(@"send failed");
        }
    } else {
        [self.delTweetData appendData:data];
        NSDictionary *dict = [NSPropertyListSerialization propertyListFromData:self.delTweetData mutabilityOption:NSPropertyListImmutable format:nil errorDescription:nil];
        NSInteger isSuccess = [[dict objectForKey:@"success"] integerValue];
        if (isSuccess) {
            UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Delete Successfully" message:nil delegate:deleteTwitterViewController cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            successAlert.tag = 1;
            [successAlert show];
        } else {
            UIAlertView *authFail= [[UIAlertView alloc] initWithTitle:@"Authentication Failed" message:nil delegate:deleteTwitterViewController cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
            authFail.tag = 2;
            [authFail show];
        }
    }
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    if (connection == self.getTweetsConnection) {
        self.getTweetsData = nil;
    } else if (connection ==self.sendTweetConnection) {
        self.sendTweetData = nil;
    } else {
        self.delTweetData = nil;
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == self.getTweetsConnection) {
        NSError *error;
        NSArray *newTweets = [NSPropertyListSerialization propertyListWithData:self.getTweetsData options:NSPropertyListMutableContainersAndLeaves format:NULL error:&error];
        TwitterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        for (NSDictionary *dict in newTweets) {
            Tweets *newTweet = [[Tweets alloc] init];
            newTweet.tweetId = [[dict objectForKey:@"id"] integerValue];
            newTweet.isdeleted = [[dict objectForKey:@"isdeleted"] integerValue];
            newTweet.tweet = [dict objectForKey:@"tweet"];
            newTweet.handle = [dict objectForKey:@"handle"];
            newTweet.wsuid = [dict objectForKey:@"wsuid"];
            newTweet.tstamp = [dict objectForKey:@"tstamp"];
            self.dateString = [dict objectForKey:@"tstamp"];
            if (newTweet.isdeleted == 0) {
                [appDelegate.tweets addObject:newTweet];
            } else { //handle deleted operation, to delete a tweet, find the old tweet with that ID, replace the content to "[deleted]", update time stamp
                BOOL isOld = NO;   //decide if this deletion is already in the record
                for (Tweets *oldTweet in appDelegate.tweets) { //if found the old tweet perform the substitution
                    if (oldTweet.tweetId == newTweet.tweetId) {
                        oldTweet.isdeleted = 1;
                        oldTweet.tweet = @"[deleted]";
                        oldTweet.tstamp = newTweet.tstamp;
                        isOld = YES;
                    }
                }
                if (isOld == NO) { //if not found, add the deletion as a new tweet
                    [appDelegate.tweets addObject:newTweet];
                }
            }
        }
        self.getTweetsData = nil;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self.tableView reloadData];
        self.fetchButton.enabled = YES;
    } else if (connection == self.sendTweetConnection) {
        self.sendTweetData = nil;
    } else {
        self.delTweetData = nil;
    }
}

- (IBAction)fetchTweets:(id)sender {
    self.fetchButton.enabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
#ifdef USING_BACKGROUND_OPERATION
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadTweets:)  object:nil];
    [q addOperation:op];
#else
    static NSString *getTweetCGI = @"http://ezekiel.vancouver.wsu.edu/~cs458/cgi-bin/get-tweets.cgi";
    //static NSString *getTweetCGI = @"http://ezekiel.vancouver.wsu.edu/~wayne/cgi-bin/get-tweets.cgi";
    NSString *encodedDateString = [self.dateString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *query = [NSString stringWithFormat:@"%@?date=%@", getTweetCGI, encodedDateString];
    NSLog(@"%@",query);
    NSURL *url = [NSURL URLWithString:query];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    self.getTweetsConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (self.getTweetsConnection) {
        self.getTweetsData = [[NSMutableData alloc] init];
    } else {
        NSLog(@"connection failed");
        return;
    }
#endif
}

-(void)addTweet: (NSURL*)url {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    self.sendTweetConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (self.sendTweetConnection) {
        self.sendTweetData = [[NSMutableData alloc] init];
        return;
    } else {
        NSLog(@"connection failed");
        return;
    }
}

-(void)delTweet: (NSURL*)url {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    self.delTweetConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (self.delTweetConnection) {
        self.delTweetData = [[NSMutableData alloc] init];
        return;
    } else {
        NSLog(@"connection failed");
        return;
    }
}


















@end
