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
#import "NSMutableData+MEAdditions.h"


#define MENotImplemented(x)     NSLog(@"NotImplemented %@", x)


static NSString *kMultipartBoundary        = @"----YAMETOO";


static NSString *kNonce                    = @"1A3D485B";
static NSString *kAppKey                   = @"e9a4f3c223bba69df0b1347d755b8c38";

static NSString *kLoginURLFormat           = @"http://me2day.net/api/noop.json?uid=%@&ukey=%@&akey=%@";
static NSString *kCreateCommentURLFormat   = @"http://me2day.net/api/create_comment.json?uid=%@&ukey=%@&akey=%@&post_id=%@";
static NSString *kCreatePostURLFormat      = @"http://me2day.net/api/create_post/%@.json?uid=%@&ukey=%@&akey=%@";
static NSString *kDeleteCommentURLFormat   = @"http://me2day.net/api/delete_comment.json?uid=%@&ukey=%@&akey=%@&comment_id=%@";
static NSString *kGetCommentsURLFormat     = @"http://me2day.net/api/get_comments.json?post_id=%@";
static NSString *kGetFriendsURLFormat      = @"http://me2day.net/api/get_friends/%@.json";
static NSString *kGetMetoosURLFormat       = @"http://me2day.net/api/get_metoos.json?post_id=%@";
static NSString *kGetPersonURLFormat       = @"http://me2day.net/api/get_person/%@.json";
static NSString *kGetPostsURLFormat        = @"http://me2day.net/api/get_posts/%@.json?scope=%@&offset=%d&count=%d";
static NSString *kGetSettingsURLFormat     = @"http://me2day.net/api/get_settings.json?uid=%@&ukey=%@&akey=%@";
static NSString *kGetTagsURLFormat         = @"http://me2day.net/api/get_tags.json?user_id=%@";
static NSString *kMetooURLFormat           = @"http://me2day.net/api/metoo.json?uid=%@&ukey=%@&akey=%@&post_id=%@";
static NSString *kTrackCommentsURLFormat   = @"http://me2day.net/api/track_comments/%@.json?scope=%@";


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

    sURLStr  = [NSString stringWithFormat:kLoginURLFormat, aUserID, mAuthKey, kAppKey];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)createCommentRequestWithPostID:(NSString *)aPostID body:(NSString *)aBody
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;
    NSData              *sPostData;

    sURLStr   = [NSString stringWithFormat:kCreateCommentURLFormat, mUserID, mAuthKey, kAppKey, [aPostID stringByAddingPercentEscapes]];
    sPostData = [[NSString stringWithFormat:@"body=%@", [aBody stringByAddingPercentEscapes]] dataUsingEncoding:NSUTF8StringEncoding];
    sRequest  = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    [sRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [sRequest setHTTPMethod:@"POST"];
    [sRequest setHTTPBody:sPostData];

    return sRequest;
}


- (NSMutableURLRequest *)createPostRequestWithBody:(NSString *)aBody
                                              tags:(NSString *)aTags
                                              icon:(NSInteger)aIcon
                                     attachedImage:(UIImage *)aImage
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;
    NSMutableData       *sPostData;

    sURLStr   = [NSString stringWithFormat:kCreatePostURLFormat, mUserID, mUserID, mAuthKey, kAppKey];
    sPostData = [NSMutableData data];
    sRequest  = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    if (aImage)
    {
        [sPostData appendUTF8String:[NSString stringWithFormat:@"--%@\r\n", kMultipartBoundary]];
        [sPostData appendUTF8String:@"Content-Disposition: form-data; name=\"post[body]\"\r\n\r\n"];
        [sPostData appendUTF8String:aBody];
        [sPostData appendUTF8String:@"\r\n"];

        [sPostData appendUTF8String:[NSString stringWithFormat:@"--%@\r\n", kMultipartBoundary]];
        [sPostData appendUTF8String:@"Content-Disposition: form-data; name=\"post[tags]\"\r\n\r\n"];
        [sPostData appendUTF8String:aTags];
        [sPostData appendUTF8String:@"\r\n"];

        [sPostData appendUTF8String:[NSString stringWithFormat:@"--%@\r\n", kMultipartBoundary]];
        [sPostData appendUTF8String:@"Content-Disposition: form-data; name=\"post[icon]\"\r\n\r\n"];
        [sPostData appendUTF8String:[NSString stringWithFormat:@"%d", aIcon]];
        [sPostData appendUTF8String:@"\r\n"];

        [sPostData appendUTF8String:[NSString stringWithFormat:@"--%@\r\n", kMultipartBoundary]];
        [sPostData appendUTF8String:@"Content-Disposition: form-data; name=\"attachment\"; filename=\"attached_file.jpg\"\r\n"];
        [sPostData appendUTF8String:@"Content-Type: image/jpeg\r\n\r\n"];
        [sPostData appendData:UIImageJPEGRepresentation(aImage, 0.8)];
        [sPostData appendUTF8String:@"\r\n"];

        [sPostData appendUTF8String:[NSString stringWithFormat:@"--%@--\r\n", kMultipartBoundary]];

        [sRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kMultipartBoundary] forHTTPHeaderField:@"Content-Type"];
    }
    else
    {
        [sPostData appendUTF8String:[NSString stringWithFormat:@"%@=%@", [@"post[body]" stringByAddingPercentEscapes], [aBody stringByAddingPercentEscapes]]];
        [sPostData appendUTF8String:[NSString stringWithFormat:@"&%@=%@", [@"post[tags]" stringByAddingPercentEscapes], [aTags stringByAddingPercentEscapes]]];
        [sPostData appendUTF8String:[NSString stringWithFormat:@"&%@=%d", [@"post[icon]" stringByAddingPercentEscapes], aIcon]];

        [sRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    }

    [sRequest setHTTPMethod:@"POST"];
    [sRequest setHTTPBody:sPostData];

    return sRequest;
}


- (NSMutableURLRequest *)deleteCommentRequestWithCommentID:(NSString *)aCommentID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kDeleteCommentURLFormat, mUserID, mAuthKey, kAppKey, aCommentID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getCommentsRequestWithPostID:(NSString *)aPostID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetCommentsURLFormat, aPostID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getFriendsRequestWithUserID:(NSString *)aUserID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetFriendsURLFormat, aUserID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getMetoosRequestWithPostID:(NSString *)aPostID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetMetoosURLFormat, aPostID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getPersonRequestWithUserID:(NSString *)aUserID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetPersonURLFormat, aUserID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getPostsRequestWithUserID:(NSString *)aUserID scope:(MEClientGetPostsScope)aScope offset:(NSInteger)aOffset count:(NSInteger)aCount
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetPostsURLFormat, aUserID, kGetPostsScopeValue[aScope], aOffset, aCount];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getSettingsRequest
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetSettingsURLFormat, mUserID, mAuthKey, kAppKey];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)getTagsRequestWithUserID:(NSString *)aUserID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kGetTagsURLFormat, aUserID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)metooRequestWithPostID:(NSString *)aPostID
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kMetooURLFormat, mUserID, mAuthKey, kAppKey, aPostID];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


- (NSMutableURLRequest *)trackCommentsRequestWithScope:(NSString *)aScope
{
    NSMutableURLRequest *sRequest;
    NSString            *sURLStr;

    sURLStr  = [NSString stringWithFormat:kTrackCommentsURLFormat, mUserID, aScope];
    sRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithUnescapedString:sURLStr]];

    return sRequest;
}


@end
