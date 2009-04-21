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
#import "MEImageCache.h"
#import "MEPost.h"


NSString *MEClientErrorDomain = @"MEClientErrorDomain";


static NSOperationQueue    *gOperationQueue    = nil;
static NSMutableDictionary *gLoadImageContexts = nil;


@implementation MEClient


+ (void)initialize
{
    if (!gOperationQueue)
    {
        gOperationQueue = [[NSOperationQueue alloc] init];
    }

    if (!gLoadImageContexts)
    {
        gLoadImageContexts = [[NSMutableDictionary alloc] init];
    }
}


#pragma mark -
#pragma mark properties


@synthesize userID   = mUserID;
@synthesize passcode = mPasscode;


#pragma mark -
#pragma mark init/dealloc


- (void)dealloc
{
    [mUserID release];
    [mAuthKey release];
    [mPasscode release];
    [super dealloc];
}


#pragma mark -
#pragma mark NSCoding


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];

    if (self)
    {
        mUserID   = [[aCoder decodeObjectForKey:@"userID"] retain];
        mAuthKey  = [[aCoder decodeObjectForKey:@"authKey"] retain];
        mPasscode = [[aCoder decodeObjectForKey:@"passcode"] retain];
    }

    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:mUserID forKey:@"userID"];
    [aCoder encodeObject:mAuthKey forKey:@"authKey"];
    [aCoder encodeObject:mPasscode forKey:@"passcode"];
}


#pragma mark -
#pragma mark comparing


- (NSComparisonResult)compareByUserID:(MEClient *)aClient
{
    return [[self userID] compare:[aClient userID]];
}


#pragma mark -
#pragma mark client behaviors


- (void)loadImageWithURL:(NSURL *)aURL key:(NSString *)aKey shouldCache:(BOOL)aShouldCache delegate:(id)aDelegate
{
    NSDictionary *sContext;

    if (aShouldCache)
    {
        UIImage *sImage = [MEImageCache imageForURL:aURL];

        if (sImage)
        {
            [aDelegate client:self didLoadImage:sImage key:aKey error:nil];
            return;
        }
        else
        {
            NSMutableArray *sWaitingContexts;

            sContext         = [NSDictionary dictionaryWithObjectsAndKeys:aDelegate, @"delegate", aURL, @"url", aKey, @"key", nil];
            sWaitingContexts = [gLoadImageContexts objectForKey:aURL];

            if (sWaitingContexts)
            {
                [sWaitingContexts addObject:sContext];
                return;
            }
            else
            {
                [gLoadImageContexts setObject:[NSMutableArray array] forKey:aURL];
            }
        }
    }
    else
    {
        sContext = [NSDictionary dictionaryWithObjectsAndKeys:aDelegate, @"delegate", aKey, @"key", nil];
    }

    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[NSMutableURLRequest requestWithURL:aURL]];
    [sOperation setContext:sContext];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveImageResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


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


- (void)getPostsWithUserID:(NSString *)aUserID offset:(NSInteger)aOffset count:(NSInteger)aCount delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self getPostsRequestWithUserID:aUserID offset:aOffset count:aCount]];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveGetPostsResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


- (void)getPersonWithUserID:(NSString *)aUserID delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self getPersonRequestWithUserID:aUserID]];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveGetPersonResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


#pragma mark -
#pragma mark retreive error from response


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


#pragma mark -
#pragma mark network operation delegation


- (void)clientOperation:(MEClientOperation *)aOperation didReceiveImageResult:(NSData *)aData error:(NSError *)aError
{
    NSString     *sKey        = [[aOperation context] objectForKey:@"key"];
    NSURL        *sURL        = [[aOperation context] objectForKey:@"url"];
    id            sDelegate   = [[aOperation context] objectForKey:@"delegate"];
    NSInvocation *sInvocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@:@@@@"]];
    id            sNil        = nil;
    NSDictionary *sContext;

    if (aError)
    {
        [sInvocation setSelector:@selector(client:didLoadImage:key:error:)];
        [sInvocation setArgument:&self atIndex:2];
        [sInvocation setArgument:&sNil atIndex:3];
        [sInvocation setArgument:&sKey atIndex:4];
        [sInvocation setArgument:&aError atIndex:5];
    }
    else
    {
        UIImage *sImage = [UIImage imageWithData:aData];

        if (sURL)
        {
            [MEImageCache storeImage:sImage data:aData forURL:sURL];
        }

        [sInvocation setSelector:@selector(client:didLoadImage:key:error:)];
        [sInvocation setArgument:&self atIndex:2];
        [sInvocation setArgument:&sImage atIndex:3];
        [sInvocation setArgument:&sKey atIndex:4];
        [sInvocation setArgument:&sNil atIndex:5];
    }

    [sInvocation invokeWithTarget:sDelegate];

    for (sContext in [gLoadImageContexts objectForKey:sURL])
    {
        sKey = [sContext objectForKey:@"key"];
        [sInvocation setArgument:&sKey atIndex:4];
        [sInvocation invokeWithTarget:[sContext objectForKey:@"delegate"]];
    }

    [gLoadImageContexts removeObjectForKey:sURL];
}


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


- (void)clientOperation:(MEClientOperation *)aOperation didReceiveGetPostsResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [aOperation context];

    if (aError)
    {
        [sDelegate client:self didGetPosts:nil error:aError];
    }
    else
    {
        NSAutoreleasePool *sPool   = [[NSAutoreleasePool alloc] init];
        NSString          *sSource = [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];
        NSArray           *sResult = [sSource JSONValue];

        if (sResult)
        {
            NSDictionary   *sPostDict;
            NSMutableArray *sPosts;

            sPosts = [NSMutableArray arrayWithCapacity:[sResult count]];

            for (sPostDict in sResult)
            {
                [sPosts addObject:[[[MEPost alloc] initWithDictionary:sPostDict] autorelease]];
            }

            [sDelegate client:self didGetPosts:sPosts error:nil];
        }
        else
        {
            [sDelegate client:self didGetPosts:nil error:[self errorFromResultString:sSource]];
        }

        [sPool release];
    }
}


- (void)clientOperation:(MEClientOperation *)aOperation didReceiveGetPersonResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [aOperation context];

    if (aError)
    {
        [sDelegate client:self didGetPerson:nil error:aError];
    }
    else
    {
        NSAutoreleasePool *sPool   = [[NSAutoreleasePool alloc] init];
        NSString          *sSource = [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary      *sResult = [sSource JSONValue];

        if (sResult)
        {
            MEUser *sUser = [[[MEUser alloc] initWithDictionary:sResult] autorelease];

            [sDelegate client:self didGetPerson:sUser error:nil];
        }
        else
        {
            [sDelegate client:self didGetPerson:nil error:[self errorFromResultString:sSource]];
        }

        [sPool release];
    }
}


@end
