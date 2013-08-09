//
//  TwitterAppDelegate.m
//  Twitter
//
//  Created by Bo Wang on 3/7/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "TwitterAppDelegate.h"
#import "Tweets.h"
#import "TwitterTableViewController.h"

@interface TwitterAppDelegate ()

-(NSString*)tweetsPath;

@end

@implementation TwitterAppDelegate

-(NSString*)tweetsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fileName = [docDir stringByAppendingPathComponent:@"tweets.archive"];
    return fileName;
}

#define tweetsKey @"tweets"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSString *fileName = [self tweetsPath];
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *s = [unarchiver decodeObjectForKey:tweetsKey];
        self.tweets = [s mutableCopy];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"PST"]];
        self.refreshDateString = @"1970-01-01 00:00:00";
        NSDate *refreshDate = [dateFormatter dateFromString:self.refreshDateString];
        for (Tweets *tweet in self.tweets) {
            NSDate *nextRefreshDate = [dateFormatter dateFromString:tweet.tstamp];
            if ([nextRefreshDate compare:refreshDate] == NSOrderedDescending) {
                refreshDate = nextRefreshDate;
            }
        }
        self.refreshDateString = [dateFormatter stringFromDate:refreshDate];//Find out the latest time stamp
        [unarchiver finishDecoding];
    } else {
        self.tweets = [[NSMutableArray alloc] init];
    }
    //self.tweets = [[NSMutableArray alloc] init];
    //self.refreshDateString = @"1970-01-01 00:00:00";
    self.userinfoArray = [[NSMutableArray alloc] init];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"applicationDidEnterBackground:");
    NSString *fileName = [self tweetsPath];
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    NSMutableArray *savedTweets = [[NSMutableArray alloc] init];
    for (Tweets *tweet in self.tweets) {
            NSLog(@"%@",tweet.tstamp);
            [savedTweets addObject:tweet];
    }
    [archiver encodeObject:savedTweets forKey:tweetsKey];
    [archiver finishEncoding];
    [data writeToFile:fileName atomically:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
