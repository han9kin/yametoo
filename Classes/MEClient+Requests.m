/*
 *  MEClient+Requests.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEClient+Requests.h"


#define MENotImplemented(x)     NSLog(@"NotImplemented %@", x)


@implementation MEClient (Requests)


- (NSURLRequest *)loginRequest
{
    NSURLRequest *sResult  = nil;
    NSString     *sAPI     = @"noop?uid=%@&ukey=%@&akey=%@";
    NSString     *sFormat  = [NSString stringWithFormat:@"%@%@", mBaseURL, sAPI];
    NSString     *sAuthKey = [self authKey];
    NSString     *sURLStr  = [NSString stringWithFormat:sFormat, mUserID, sAuthKey, mAppKey];
    NSURL        *sURL     = [NSURL URLWithString:[sURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    sResult = [NSURLRequest requestWithURL:sURL];

    return sResult;
}


- (NSURLRequest *)createCommentRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"loginRequest");    
    return sResult;
}


- (NSURLRequest *)createPostRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"createPostRequest");
    return sResult;
}


- (NSURLRequest *)deleteCommentsRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"deleteCommentsRequest");
    return sResult;
}


- (NSURLRequest *)getCommentsRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"getCommentsRequest");
    return sResult;
}


- (NSURLRequest *)getFriendsRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"getFriendsRequest");
    return sResult;
}


- (NSURLRequest *)getLatestsRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"getLatestsRequest");
    return sResult;
}


- (NSURLRequest *)getMetoosRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"getMetoosRequest");
    return sResult;
}


- (NSURLRequest *)getPersonRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"getPersonRequest");
    return sResult;
}


- (NSURLRequest *)getPostsRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"getPostsRequest");
    return sResult;
}


- (NSURLRequest *)getSettingsRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"getSettingsRequest");
    return sResult;
}


- (NSURLRequest *)getTagsRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"getTagsRequest");
    return sResult;
}


- (NSURLRequest *)metooRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"metooRequest");
    return sResult;
}


- (NSURLRequest *)trackCommentsRequest
{
    NSURLRequest *sResult = nil;
    MENotImplemented(@"trackCommentsRequest");
    return sResult;
}


@end
