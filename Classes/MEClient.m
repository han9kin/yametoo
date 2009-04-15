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


@synthesize userID  = mUserID;
@synthesize userKey = mUserKey;


#pragma mark - init/dealloc


- (void)dealloc
{
    [mUserID release];
    [mUserKey release];
    [mAuthKey release];
    [super dealloc];
}


#pragma mark -


- (void)loginWithUserID:(NSString *)aUserID userKey:(NSString *)aUserKey delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self loginRequestWithUserID:aUserID userKey:aUserKey]];
    [sOperation setContext:[NSDictionary dictionaryWithObjectsAndKeys:aDelegate, @"delegate", aUserID, @"userID", aUserKey, @"userKey", nil]];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveLoginResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}

- (void)postWithBody:(NSString *)aBody tags:(NSString *)aTags icon:(NSInteger)aIcon attachedImage:(UIImage *)aImage delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];
    NSString          *sTags      = [NSString stringWithFormat:@"yametoo %@", aTags];

    [sOperation setRequest:[self createPostRequestWithBody:aBody tags:sTags icon:aIcon attachedImage:aImage]];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceivePostResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


#pragma mark -


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
        id                 sResult = [sSource JSONValue];

        if (sResult)
        {
            [mUserID release];
            [mUserKey release];

            mUserID  = [[[aOperation context] objectForKey:@"userID"] retain];
            mUserKey = [[[aOperation context] objectForKey:@"userKey"] retain];

            [sDelegate client:self didLoginWithError:nil];
        }
        else
        {
            NSDictionary *sUserInfo = [NSDictionary dictionaryWithObject:sSource forKey:NSLocalizedDescriptionKey];
            NSError      *sError    = [NSError errorWithDomain:MEClientErrorDomain code:0 userInfo:sUserInfo];

            [sDelegate client:self didLoginWithError:sError];
        }

        [sPool release];
    }
}

- (void)clientOperation:(MEClientOperation *)aOperation didReceivePostResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [aOperation context];

    if (aError)
    {
        [sDelegate client:self didPostWithError:aError];
    }
    else
    {
        NSAutoreleasePool *sPool   = [[NSAutoreleasePool alloc] init];
        NSString          *sSource = [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];
        id                 sResult = [sSource JSONValue];

        if (sResult)
        {
            [sDelegate client:self didPostWithError:nil];
        }
        else
        {
            NSDictionary *sUserInfo = [NSDictionary dictionaryWithObject:sSource forKey:NSLocalizedDescriptionKey];
            NSError      *sError    = [NSError errorWithDomain:MEClientErrorDomain code:0 userInfo:sUserInfo];

            [sDelegate client:self didPostWithError:sError];
        }

        [sPool release];
    }
}

@end
