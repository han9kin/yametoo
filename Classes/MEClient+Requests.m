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


static NSString *kNonce                      = @"1A3D485B";
static NSString *kAppKey                     = @"e9a4f3c223bba69df0b1347d755b8c38";

static NSString *kLoginRequestFormat         = @"http://me2day.net/api/noop.json?uid=%@&ukey=%@&akey=%@";
static NSString *kCreateCommentRequestFormat = @"http://me2day.net/api/create_comment.json?uid=%@&ukey=%@&akey=%@&post_id=%@&body=%@";
static NSString *kCreatePostRequestFormat    = @"http://me2day.net/api/create_post/%@.json?uid=%@&ukey=%@&akey=%@&post[body]=%@&post[tags]=%@&post[icon]=%d";
static NSString *kDeleteCommentRequestFormat = @"http://me2day.net/api/delete_comment.json?uid=%@&ukey=%@&akey=%@&comment_id=%@";
static NSString *kGetCommentsRequestFormat   = @"http://me2day.net/api/get_comments.json?post_id=%@";
static NSString *kGetFriendsRequestFormat    = @"http://me2day.net/api/get_friends/%@.json";
static NSString *kGetMetoosRequestFormat     = @"http://me2day.net/api/get_metoos.json?post_id=%@";
static NSString *kGetPersonRequestFormat     = @"http://me2day.net/api/get_person/%@.json";
static NSString *kGetPostsRequestFormat      = @"http://me2day.net/api/get_posts/%@.json?scope=%@&offset=%d&count=%d";
static NSString *kGetSettingsRequestFormat   = @"http://me2day.net/api/get_settings.json?uid=%@&ukey=%@&akey=%@";
static NSString *kGetTagsRequestFormat       = @"http://me2day.net/api/get_tags.json?user_id=%@";
static NSString *kMetooRequestFormat         = @"http://me2day.net/api/metoo.json?uid=%@&ukey=%@&akey=%@&post_id=%@";
static NSString *kTrackCommentsRequestFormat = @"http://me2day.net/api/track_comments/%@.json?scope=%@";


static NSString *kGetPostsScopeValue[] = {
    @"all",
    @"friend[all]",
};


@implementation MEClient (Requests)


+ (NSString *)authKeyWithUserKey:(NSString *)aUserKey
{
    return [NSString stringWithFormat:@"%@%@", kNonce, [[NSString stringWithFormat:@"%@%@", kNonce, aUserKey] md5String]];
}


- (NSMutableURLRequest *)loginRequestWithUserID:(NSString *)aUserID userKey:(NSString *)aUserKey;
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    [mAuthKey release];
    mAuthKey = [[MEClient authKeyWithUserKey:aUserKey] retain];

    sURLStr  = [NSString stringWithFormat:kLoginRequestFormat, aUserID, mAuthKey, kAppKey];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)createCommentRequestWithPostID:(NSString *)aPostID body:(NSString *)aBody
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kCreateCommentRequestFormat, mUserID, mAuthKey, kAppKey, aPostID, aBody];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)createPostRequestWithBody:(NSString *)aBody
                                              tags:(NSString *)aTags
                                              icon:(NSInteger)aIcon
                                     attachedImage:(UIImage *)aImage
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kCreatePostRequestFormat, mUserID, mUserID, mAuthKey, kAppKey, aBody, aTags, aIcon];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    if (aImage)
    {
        [sRequest attachImage:aImage];
    }

    return sRequest;
}


- (NSMutableURLRequest *)deleteCommentRequestWithCommentID:(NSString *)aCommentID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kDeleteCommentRequestFormat, mUserID, mAuthKey, kAppKey, aCommentID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getCommentsRequestWithPostID:(NSString *)aPostID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetCommentsRequestFormat, aPostID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getFriendsRequestWithUserID:(NSString *)aUserID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetFriendsRequestFormat, aUserID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getMetoosRequestWithPostID:(NSString *)aPostID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetMetoosRequestFormat, aPostID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getPersonRequestWithUserID:(NSString *)aUserID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetPersonRequestFormat, aUserID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getPostsRequestWithUserID:(NSString *)aUserID scope:(MEClientGetPostsScope)aScope offset:(NSInteger)aOffset count:(NSInteger)aCount
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetPostsRequestFormat, aUserID, kGetPostsScopeValue[aScope], aOffset, aCount];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getSettingsRequest
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetSettingsRequestFormat, mUserID, mAuthKey, kAppKey];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getTagsRequestWithUserID:(NSString *)aUserID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetTagsRequestFormat, aUserID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)metooRequestWithPostID:(NSString *)aPostID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kMetooRequestFormat, mUserID, mAuthKey, kAppKey, aPostID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)trackCommentsRequestWithScope:(NSString *)aScope
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kTrackCommentsRequestFormat, mUserID, aScope];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


@end
