/*
 *  MEClient+Requests.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEClient+Requests.h"
#import "NSString+MEAdditions.h"
#import "NSURL+MEAdditions.h"
#import "NSMutableURLRequest+MEAdditions.h"


#define MENotImplemented(x)     NSLog(@"NotImplemented %@", x)


static NSString *kNonce                    = @"1A3D485B";
static NSString *kAppKey                   = @"e9a4f3c223bba69df0b1347d755b8c38";

static NSString *kLoginRequestFormat       = @"http://me2day.net/api/noop.json?uid=%@&ukey=%@&akey=%@";
static NSString *kCreatePostRequestFormat  = @"http://me2day.net/api/create_post/%@.json?uid=%@&ukey=%@&akey=%@&post[body]=%@&post[tags]=%@&post[icon]=%d";
static NSString *kGetPostsRequestFormat    = @"http://me2day.net/api/get_posts/%@.json?offset=%d&count=%d";
static NSString *kGetCommentsRequestFormat = @"http://me2day.net/api/get_comments.json?post_id=%@";

@implementation MEClient (Requests)


+ (NSString *)authKeyWithUserKey:(NSString *)aUserKey
{
    return [NSString stringWithFormat:@"%@%@", kNonce, [[NSString stringWithFormat:@"%@%@", kNonce, aUserKey] md5String]];
}


- (NSMutableURLRequest *)loginRequestWithUserID:(NSString *)aUserID userKey:(NSString *)aUserKey;
{
    NSMutableURLRequest *sRequest;
    NSString            *sURL;

    [mAuthKey release];
    mAuthKey = [[MEClient authKeyWithUserKey:aUserKey] retain];

    sURL     = [NSString stringWithFormat:kLoginRequestFormat, aUserID, mAuthKey, kAppKey];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURL]];

    return sRequest;
}


- (NSMutableURLRequest *)createCommentRequest
{
    NSMutableURLRequest *sRequest = nil;
    MENotImplemented(@"createCommentRequest");
    return sRequest;
}


- (NSMutableURLRequest *)createPostRequestWithBody:(NSString *)aBody
                                              tags:(NSString *)aTags
                                              icon:(NSInteger)aIcon
                                     attachedImage:(UIImage *)aImage
{
    NSMutableURLRequest *sRequest;
    NSString            *sURL;

    sURL     = [NSString stringWithFormat:kCreatePostRequestFormat, mUserID, mUserID, mAuthKey, kAppKey, aBody, aTags, aIcon];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURL]];

    if (aImage)
    {
        [sRequest attachImage:aImage];
    }

    return sRequest;
}


- (NSMutableURLRequest *)deleteCommentsRequest
{
    NSMutableURLRequest *sRequest = nil;
    MENotImplemented(@"deleteCommentsRequest");
    return sRequest;
}


- (NSMutableURLRequest *)getCommentsRequestWithPostID:(NSString *)aPostID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURL;
    
    sURL     = [NSString stringWithFormat:kGetCommentsRequestFormat, aPostID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURL]];
    
    return sRequest;
}


- (NSMutableURLRequest *)getFriendsRequest
{
    NSMutableURLRequest *sRequest = nil;
    MENotImplemented(@"getFriendsRequest");
    return sRequest;
}


- (NSMutableURLRequest *)getLatestsRequest
{
    NSMutableURLRequest *sRequest = nil;
    MENotImplemented(@"getLatestsRequest");
    return sRequest;
}


- (NSMutableURLRequest *)getMetoosRequest
{
    NSMutableURLRequest *sRequest = nil;
    MENotImplemented(@"getMetoosRequest");
    return sRequest;
}


- (NSMutableURLRequest *)getPersonRequest
{
    NSMutableURLRequest *sRequest = nil;
    MENotImplemented(@"getPersonRequest");
    return sRequest;
}


- (NSMutableURLRequest *)getPostsRequestWithOffet:(NSInteger)aOffset count:(NSInteger)aCount
{
    NSMutableURLRequest *sRequest;
    NSString            *sURL;
    
    sURL     = [NSString stringWithFormat:kGetPostsRequestFormat, mUserID, aOffset, aCount];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURL]];
    
    return sRequest;
}


- (NSMutableURLRequest *)getSettingsRequest
{
    NSMutableURLRequest *sRequest = nil;
    MENotImplemented(@"getSettingsRequest");
    return sRequest;
}


- (NSMutableURLRequest *)getTagsRequest
{
    NSMutableURLRequest *sRequest = nil;
    MENotImplemented(@"getTagsRequest");
    return sRequest;
}


- (NSMutableURLRequest *)metooRequest
{
    NSMutableURLRequest *sRequest = nil;
    MENotImplemented(@"metooRequest");
    return sRequest;
}


- (NSMutableURLRequest *)trackCommentsRequest
{
    NSMutableURLRequest *sRequest = nil;
    MENotImplemented(@"trackCommentsRequest");
    return sRequest;
}


@end
