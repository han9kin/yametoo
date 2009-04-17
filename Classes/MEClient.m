/*
 *  MEClient.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <JSON/JSON.h>
#import "MEClient.h"
#import "MEClient+Requests.h"
#import "MEClientOperation.h"


NSString *MEClientErrorDomain = @"MEClientErrorDomain";


static NSOperationQueue *gOperationQueue = nil;


@implementation MEClient


+ (void)initialize
{
    if (!gOperationQueue)
    {
        gOperationQueue = [[NSOperationQueue alloc] init];
    }
}


#pragma mark - properties


@synthesize userID   = mUserID;
@synthesize passcode = mPasscode;


#pragma mark - init/dealloc


- (void)dealloc
{
    [mUserID release];
    [mAuthKey release];
    [mPasscode release];
    [super dealloc];
}


#pragma mark - client behaviors


- (void)loginWithUserID:(NSString *)aUserID userKey:(NSString *)aUserKey delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self loginRequestWithUserID:aUserID userKey:aUserKey]];
    [sOperation setContext:[NSDictionary dictionaryWithObjectsAndKeys:aDelegate, @"delegate", aUserID, @"userID", nil]];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveLoginResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}

- (void)createPostWithBody:(NSString *)aBody tags:(NSString *)aTags icon:(NSInteger)aIcon attachedImage:(UIImage *)aImage delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self createPostRequestWithBody:aBody tags:[aTags stringByAppendingString:@" yametoo"] icon:aIcon attachedImage:aImage]];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveCreatePostResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}

- (void)createCommentWithPostID:(NSString *)aPostID body:(NSString *)aBody delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self createCommentRequestWithPostID:aPostID body:aBody]];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveCreateCommentResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


#pragma mark - retreive error from response


- (NSError *)errorFromResultString:(NSString *)aString
{
    NSDictionary *sUserInfo;
    NSError      *sError;

    sUserInfo = [NSDictionary dictionaryWithObject:aString forKey:NSLocalizedDescriptionKey];
    sError    = [NSError errorWithDomain:MEClientErrorDomain code:-1 userInfo:sUserInfo];

    return sError;
}

- (NSError *)errorFromResultDictionary:(NSDictionary *)aDict
{
    NSInteger     sCode;
    NSString     *sMessage;
    NSDictionary *sUserInfo;
    NSError      *sError;

    sCode = [[aDict objectForKey:@"code"] integerValue];

    if (sCode)
    {
        if ([[aDict objectForKey:@"description"] length])
        {
            sMessage = [aDict objectForKey:@"description"];
        }
        else if ([[aDict objectForKey:@"message"] length])
        {
            sMessage = [aDict objectForKey:@"message"];
        }
        else
        {
            sMessage = @"Unknown";
        }

        sUserInfo = [NSDictionary dictionaryWithObject:sMessage forKey:NSLocalizedDescriptionKey];
        sError    = [NSError errorWithDomain:MEClientErrorDomain code:sCode userInfo:sUserInfo];

        return sError;
    }
    else
    {
        return nil;
    }
}


#pragma mark - network operation delegation


- (void)clientOperation:(MEClientOperation *)aOperation didReceiveLoginResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [[aOperation context] objectForKey:@"delegate"];

    if (aError)
    {
        [sDelegate client:self didLoginWithError:aError];
    }
    else
    {
        NSAutoreleasePool *sPool   = [[NSAutoreleasePool alloc] init];
        NSString          *sSource = [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary      *sResult = [sSource JSONValue];
        NSError           *sError;

        if (sResult)
        {
            sError = [self errorFromResultDictionary:sResult];

            if (sError)
            {
                [sDelegate client:self didLoginWithError:sError];
            }
            else
            {
                [mUserID release];
                mUserID = [[[aOperation context] objectForKey:@"userID"] retain];

                [sDelegate client:self didLoginWithError:nil];
            }
        }
        else
        {
            [sDelegate client:self didLoginWithError:[self errorFromResultString:sSource]];
        }

        [sPool release];
    }
}

- (void)clientOperation:(MEClientOperation *)aOperation didReceiveCreatePostResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [aOperation context];

    if (aError)
    {
        [sDelegate client:self didCreatePostWithError:aError];
    }
    else
    {
        NSAutoreleasePool *sPool   = [[NSAutoreleasePool alloc] init];
        NSString          *sSource = [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];
        id                 sResult = [sSource JSONValue];

        if (sResult)
        {
            [sDelegate client:self didCreatePostWithError:nil];
        }
        else
        {
            NSDictionary *sUserInfo = [NSDictionary dictionaryWithObject:sSource forKey:NSLocalizedDescriptionKey];
            NSError      *sError    = [NSError errorWithDomain:MEClientErrorDomain code:0 userInfo:sUserInfo];

            [sDelegate client:self didCreatePostWithError:sError];
        }

        [sPool release];
    }
}

- (void)clientOperation:(MEClientOperation *)aOperation didReceiveCreateCommentResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [[aOperation context] objectForKey:@"delegate"];

    if (aError)
    {
        [sDelegate client:self didCreateCommentWithError:aError];
    }
    else
    {
        NSAutoreleasePool *sPool   = [[NSAutoreleasePool alloc] init];
        NSString          *sSource = [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary      *sResult = [sSource JSONValue];
        NSError           *sError;

        if (sResult)
        {
            sError = [self errorFromResultDictionary:sResult];

            if (sError)
            {
                [sDelegate client:self didCreateCommentWithError:sError];
            }
            else
            {
                [sDelegate client:self didCreateCommentWithError:nil];
            }
        }
        else
        {
            [sDelegate client:self didCreateCommentWithError:[self errorFromResultString:sSource]];
        }

        [sPool release];
    }
}


@end
