//
//  Tweets.m
//  Twitter
//
//  Created by Bo Wang on 3/7/13.
//  Copyright (c) 2013 Bo Wang. All rights reserved.
//

#import "Tweets.h"

@implementation Tweets

-(id)init {
    if (self = [super init]) {
        self.tweetId = 0;
        self.wsuid = @"<wsuid>";
        self.handle = @"<handle>";
        self.isdeleted = 0;
        self.tstamp = @"<tstamp>";
        self.tweet = @"<tweet>";
        
    }
    return self;
}

#define kId @"id"
#define kWsuid @"wsuid"
#define kHandle @"handle"
#define kIsdeleted @"isdeleted"
#define kTweet @"tweet"
#define kTstamp @"tstamp"

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.tweetId = [aDecoder decodeIntegerForKey:kId];
        self.wsuid = [aDecoder decodeObjectForKey:kWsuid];
        self.handle = [aDecoder decodeObjectForKey:kHandle];
        self.isdeleted = [aDecoder decodeIntegerForKey:kIsdeleted];
        self.tstamp = [aDecoder decodeObjectForKey:kTstamp];
        self.tweet = [aDecoder decodeObjectForKey:kTweet];
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.tweetId forKey:kId];
    [aCoder encodeObject:self.wsuid forKey:kWsuid];
    [aCoder encodeObject:self.handle forKey:kHandle];
    [aCoder encodeInteger:self.isdeleted forKey:kIsdeleted];
    [aCoder encodeObject:self.tstamp forKey:kTstamp];
    [aCoder encodeObject:self.tweet forKey:kTweet];
}

-(id)copyWithZone:(NSZone *)zone {
    Tweets *tweet = [[[self class] allocWithZone:zone] init];
    tweet.tweetId = self.tweetId;
    tweet.wsuid = self.wsuid;
    tweet.handle = self.handle;
    tweet.tstamp = self.tstamp;
    tweet.isdeleted = self.isdeleted;
    tweet.tweet = self.tweet;
    return tweet;
}

@end
