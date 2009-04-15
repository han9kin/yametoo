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

- (NSMutableURLRequest *)loginRequestWithUserID:(NSString *)aUserID userKey:(NSString *)aUserKey;
- (NSMutableURLRequest *)createCommentRequest;
- (NSMutableURLRequest *)createPostRequestWithBody:(NSString *)aBody
                                              tags:(NSString *)aTags
                                              icon:(NSInteger)aIcon
                                     attachedImage:(UIImage *)aImage;
- (NSMutableURLRequest *)deleteCommentsRequest;
- (NSMutableURLRequest *)getCommentsRequest;
- (NSMutableURLRequest *)getFriendsRequest;
- (NSMutableURLRequest *)getLatestsRequest;
- (NSMutableURLRequest *)getMetoosRequest;
- (NSMutableURLRequest *)getPersonRequest;
- (NSMutableURLRequest *)getPostsRequest;
- (NSMutableURLRequest *)getSettingsRequest;
- (NSMutableURLRequest *)getTagsRequest;
- (NSMutableURLRequest *)metooRequest;
- (NSMutableURLRequest *)trackCommentsRequest;

@end
