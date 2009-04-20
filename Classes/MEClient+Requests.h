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

- (NSMutableURLRequest *)loginRequestWithUserID:(NSString *)aUserID
                                        userKey:(NSString *)aUserKey;
- (NSMutableURLRequest *)createCommentRequestWithPostID:(NSString *)aPostID
                                                   body:(NSString *)aBody;
- (NSMutableURLRequest *)createPostRequestWithBody:(NSString *)aBody
                                              tags:(NSString *)aTags
                                              icon:(NSInteger)aIcon
                                     attachedImage:(UIImage *)aImage;
- (NSMutableURLRequest *)deleteCommentRequestWithCommentID:(NSString *)aCommentID;
- (NSMutableURLRequest *)getCommentsRequestWithPostID:(NSString *)aPostID;
- (NSMutableURLRequest *)getFriendsRequestWithUserID:(NSString *)aUserID;
- (NSMutableURLRequest *)getMetoosRequestWithPostID:(NSString *)aPostID;
- (NSMutableURLRequest *)getPersonRequestWithUserID:(NSString *)aUserID;
- (NSMutableURLRequest *)getPostsRequestWithUserID:(NSString *)aUserID
                                            offset:(NSInteger)aOffset
                                             count:(NSInteger)aCount;
- (NSMutableURLRequest *)getSettingsRequest;
- (NSMutableURLRequest *)getTagsRequestWithUserID:(NSString *)aUserID;
- (NSMutableURLRequest *)metooRequestWithPostID:(NSString *)aPostID;
- (NSMutableURLRequest *)trackCommentsRequestWithScope:(NSString *)aScope;

@end
