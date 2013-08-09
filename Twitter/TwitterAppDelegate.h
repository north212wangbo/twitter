//
//  TwitterAppDelegate.h
//  Twitter
//
//  Created by Bo Wang on 3/7/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (copy, nonatomic) NSString *refreshDateString;

@property (strong, nonatomic) NSMutableArray *userinfoArray;    //store temporary 'wsuid' and 'handle' information

@end
