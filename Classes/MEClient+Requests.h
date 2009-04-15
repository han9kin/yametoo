/*
 *  MEClient+Requests.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "MEClient.h"


@interface MEClient (Requests)

- (NSURLRequest *)loginRequest;
- (NSURLRequest *)createCommentRequest;
- (NSURLRequest *)createPostRequest;
- (NSURLRequest *)deleteCommentsRequest;
- (NSURLRequest *)getCommentsRequest;
- (NSURLRequest *)getFriendsRequest;
- (NSURLRequest *)getLatestsRequest;
- (NSURLRequest *)getMetoosRequest;
- (NSURLRequest *)getPersonRequest;
- (NSURLRequest *)getPostsRequest;
- (NSURLRequest *)getSettingsRequest;
- (NSURLRequest *)getTagsRequest;
- (NSURLRequest *)metooRequest;
- (NSURLRequest *)trackCommentsRequest;

@end
