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


- (NSMutableURLRequest *)loginRequest
{
    NSMutableURLRequest *sResult  = nil;
    NSString            *sAPI     = @"noop?uid=%@&ukey=%@&akey=%@";
    NSString            *sFormat  = [NSString stringWithFormat:@"%@%@", mBaseURL, sAPI];
    NSString            *sAuthKey = [self authKey];
    NSString            *sURLStr  = [NSString stringWithFormat:sFormat, mUserID, sAuthKey, mAppKey];
    NSURL               *sURL     = [NSURL URLWithString:[sURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    sResult = [NSMutableURLRequest requestWithURL:sURL];

    return sResult;
}


- (NSMutableURLRequest *)createCommentRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"loginRequest");    
    return sResult;
}


- (NSMutableURLRequest *)createPostRequestWithBody:(NSString *)aBody
                                              tags:(NSString *)aTags
                                              icon:(NSInteger)aIcon
                                     attachedImage:(UIImage *)aImage
{
    NSMutableURLRequest *sResult  = nil;
    NSString            *sAPI     = @"create_post/%@.json?uid=%@&ukey=%@&akey=%@&post[body]=%@&post[tags]=%@&post[icon]=%d";
    NSString            *sFormat  = [NSString stringWithFormat:@"%@%@", mBaseURL, sAPI];
    NSString            *sAuthKey = [self authKey];
    NSString            *sURLStr  = [NSString stringWithFormat:sFormat, mUserID, mUserID, sAuthKey, mAppKey, aBody, aTags, aIcon];
    NSURL               *sURL     = [NSURL URLWithString:[sURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    if (aImage)
    {
        NSString            *sBoundary    = @"----YAMETOO";
        NSString            *sContentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", sBoundary];
        NSMutableURLRequest *sRequest     = [NSMutableURLRequest requestWithURL:sURL];
        NSMutableData       *sPostBody    = [NSMutableData data];
        
        [sPostBody appendData:[[NSString stringWithFormat:@"--%@\r\n", sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [sPostBody appendData:[@"Content-Disposition: form-data; name=\"attachment\"; filename=\"attached_file\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [sPostBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [sPostBody appendData:UIImageJPEGRepresentation(aImage, 0.8)];
        [sPostBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];

        [sRequest setHTTPMethod:@"POST"];
        [sRequest setValue:sContentType forHTTPHeaderField:@"Content-type"];
        [sRequest setHTTPBody:sPostBody];        
        
    }
    else
    {
        sResult = [NSMutableURLRequest requestWithURL:sURL];    
    }
    
    return sResult;
}


- (NSMutableURLRequest *)deleteCommentsRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"deleteCommentsRequest");
    return sResult;
}


- (NSMutableURLRequest *)getCommentsRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"getCommentsRequest");
    return sResult;
}


- (NSMutableURLRequest *)getFriendsRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"getFriendsRequest");
    return sResult;
}


- (NSMutableURLRequest *)getLatestsRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"getLatestsRequest");
    return sResult;
}


- (NSMutableURLRequest *)getMetoosRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"getMetoosRequest");
    return sResult;
}


- (NSMutableURLRequest *)getPersonRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"getPersonRequest");
    return sResult;
}


- (NSMutableURLRequest *)getPostsRequest;
{
    NSMutableURLRequest *sResult  = nil;
    MENotImplemented(@"getPostsRequest");    
    return sResult;
}


- (NSMutableURLRequest *)getSettingsRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"getSettingsRequest");
    return sResult;
}


- (NSMutableURLRequest *)getTagsRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"getTagsRequest");
    return sResult;
}


- (NSMutableURLRequest *)metooRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"metooRequest");
    return sResult;
}


- (NSMutableURLRequest *)trackCommentsRequest
{
    NSMutableURLRequest *sResult = nil;
    MENotImplemented(@"trackCommentsRequest");
    return sResult;
}


@end
