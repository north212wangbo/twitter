//
//  Tweets.h
//  Twitter
//
//  Created by Bo Wang on 3/7/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweets : NSObject

@property (nonatomic) NSInteger tweetId;
@property (copy,nonatomic) NSString *wsuid;
@property (copy,nonatomic) NSString *handle;
@property (nonatomic) NSInteger isdeleted;
@property (copy,nonatomic) NSString *tstamp;
@property (copy,nonatomic) NSString *tweet;

@end
