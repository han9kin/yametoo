/*
 *  MEClient.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <stdlib.h>
#import <time.h>
#import <unistd.h>
#import <JSON/JSON.h>
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEClient+Requests.h"
#import "MEClientOperation.h"
#import "MEImageCache.h"
#import "MEUser.h"
#import "MEPost.h"
#import "MEComment.h"


NSString *MEClientErrorDomain = @"MEClientErrorDomain";


static NSOperationQueue    *gOperationQueue   = nil;
static NSMutableDictionary *gQueuedOperations = nil;


@implementation MEClient


+ (void)initialize
{
    if (!gOperationQueue)
    {
        gOperationQueue = [[NSOperationQueue alloc] init];
    }

    if (!gQueuedOperations)
    {
        gQueuedOperations = [[NSMutableDictionary alloc] init];
    }
}


#pragma mark -
#pragma mark properties


@synthesize userID = mUserID;


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
#pragma mark passcode


- (void)setPasscode:(NSString *)aPasscode
{
    [mPasscode release];

    if (aPasscode)
    {
        char sSalt[3];

        srandom(time(NULL));

        sSalt[0] = 'a' + random() % 26;
        sSalt[1] = 'a' + random() % 26;
        sSalt[2] = 0;

        mPasscode = [[NSString alloc] initWithUTF8String:crypt([aPasscode UTF8String], sSalt)];
    }
    else
    {
        mPasscode = nil;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:MEClientStoreUserListDidChangeNotification object:nil];
}


- (BOOL)checkPasscode:(NSString *)aPasscode
{
    if (mPasscode)
    {
        return [mPasscode isEqualToString:[NSString stringWithUTF8String:crypt([aPasscode UTF8String], [mPasscode UTF8String])]];
    }
    else
    {
        return YES;
    }
}


- (BOOL)hasPasscode
{
    return mPasscode ? YES : NO;
}


#pragma mark -
#pragma mark client behaviors


- (void)loadImageWithURL:(NSURL *)aURL key:(id)aKey delegate:(id)aDelegate
{
    UIImage *sImage = [MEImageCache imageForURL:aURL];

    if (sImage)
    {
        [aDelegate client:self didLoadImage:sImage key:aKey error:nil];
    }
    else
    {
        NSDictionary   *sContext;
        NSMutableArray *sWaitingContexts;

        sContext         = [NSDictionary dictionaryWithObjectsAndKeys:aURL, @"url", aDelegate, @"delegate", aKey, @"key", nil];
        sWaitingContexts = [gQueuedOperations objectForKey:aURL];

        if (sWaitingContexts)
        {
            [sWaitingContexts addObject:sContext];
        }
        else
        {
            [gQueuedOperations setObject:[NSMutableArray array] forKey:aURL];

            MEClientOperation *sOperation = [[MEClientOperation alloc] init];

            [sOperation setRequest:[NSMutableURLRequest requestWithURL:aURL]];
            [sOperation setQueuePriority:NSOperationQueuePriorityLow];
            [sOperation setContext:sContext];
            [sOperation setDelegate:self];
            [sOperation setSelector:@selector(clientOperation:didReceiveImageResult:error:)];
            [sOperation retainContext];

            [gOperationQueue addOperation:sOperation];
            [sOperation release];
        }
    }
}


- (void)loginWithUserID:(NSString *)aUserID userKey:(NSString *)aUserKey delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self loginRequestWithUserID:aUserID userKey:aUserKey]];
    [sOperation setQueuePriority:NSOperationQueuePriorityHigh];
    [sOperation setContext:[NSDictionary dictionaryWithObjectsAndKeys:aDelegate, @"delegate", aUserID, @"userID", nil]];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveLoginResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


- (void)createCommentWithPostID:(NSString *)aPostID body:(NSString *)aBody delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self createCommentRequestWithPostID:aPostID body:aBody]];
    [sOperation setQueuePriority:NSOperationQueuePriorityHigh];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveCreateCommentResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


- (void)createPostWithBody:(NSString *)aBody tags:(NSString *)aTags icon:(NSInteger)aIcon attachedImage:(UIImage *)aImage delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self createPostRequestWithBody:aBody tags:[aTags stringByAppendingString:@" yametoo"] icon:aIcon attachedImage:aImage]];
    [sOperation setQueuePriority:NSOperationQueuePriorityHigh];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveCreatePostResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


- (void)getCommentsWithPostID:(NSString *)aPostID delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self getCommentsRequestWithPostID:aPostID]];
    [sOperation setQueuePriority:NSOperationQueuePriorityHigh];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveGetCommentsResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


- (void)getFriendsWithUserID:(NSString *)aUserID delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self getFriendsRequestWithUserID:aUserID]];
    [sOperation setQueuePriority:NSOperationQueuePriorityHigh];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveGetFriendsResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


- (void)getMetoosWithPostID:(NSString *)aPostID delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self getMetoosRequestWithPostID:aPostID]];
    [sOperation setQueuePriority:NSOperationQueuePriorityHigh];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveGetMetoosResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


- (void)getPersonWithUserID:(NSString *)aUserID delegate:(id)aDelegate
{
    NSMutableURLRequest *sRequest         = [self getPersonRequestWithUserID:aUserID];
    NSURL               *sURL             = [sRequest URL];
    NSDictionary        *sContext         = [NSDictionary dictionaryWithObjectsAndKeys:sURL, @"url", aDelegate, @"delegate", nil];
    NSMutableArray      *sWaitingContexts = [gQueuedOperations objectForKey:sURL];

    if (sWaitingContexts)
    {
        [sWaitingContexts addObject:sContext];
    }
    else
    {
        [gQueuedOperations setObject:[NSMutableArray array] forKey:sURL];

        MEClientOperation *sOperation = [[MEClientOperation alloc] init];

        [sOperation setRequest:sRequest];
        [sOperation setQueuePriority:NSOperationQueuePriorityHigh];
        [sOperation setContext:sContext];
        [sOperation setDelegate:self];
        [sOperation setSelector:@selector(clientOperation:didReceiveGetPersonResult:error:)];
        [sOperation retainContext];

        [gOperationQueue addOperation:sOperation];
        [sOperation release];
    }
}


- (void)getPostsWithUserID:(NSString *)aUserID scope:(MEClientGetPostsScope)aScope offset:(NSInteger)aOffset count:(NSInteger)aCount delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self getPostsRequestWithUserID:aUserID scope:aScope offset:aOffset count:aCount]];
    [sOperation setQueuePriority:NSOperationQueuePriorityHigh];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveGetPostsResult:error:)];
    [sOperation retainContext];

    [gOperationQueue addOperation:sOperation];
    [sOperation release];
}


- (void)metooWithPostID:(NSString *)aPostID delegate:(id)aDelegate
{
    MEClientOperation *sOperation = [[MEClientOperation alloc] init];

    [sOperation setRequest:[self metooRequestWithPostID:aPostID]];
    [sOperation setQueuePriority:NSOperationQueuePriorityHigh];
    [sOperation setContext:aDelegate];
    [sOperation setDelegate:self];
    [sOperation setSelector:@selector(clientOperation:didReceiveMetooResult:error:)];
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
        if ([[aDict objectForKey:@"message"] length] && [[aDict objectForKey:@"description"] length])
        {
            sMessage = [NSString stringWithFormat:@"%@ (%@)", [aDict objectForKey:@"message"], [aDict objectForKey:@"description"]];
        }
        else if ([[aDict objectForKey:@"message"] length])
        {
            sMessage = [aDict objectForKey:@"message"];
        }
        else if ([[aDict objectForKey:@"description"] length])
        {
            sMessage = [aDict objectForKey:@"description"];
        }
        else
        {
            sMessage = @"Unknown error from server.";
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
    UIImage      *sImage      = nil;
    NSError      *sError      = nil;
    NSDictionary *sContext;

    if (aError)
    {
        sError = aError;
    }
    else
    {
        sImage = [UIImage imageWithData:aData];

        if (sImage)
        {
            [MEImageCache storeImage:sImage data:aData forURL:sURL];
        }
        else
        {
            sError = [self errorFromResultString:@"Invalid Image Data"];
        }
    }

    [sInvocation setSelector:@selector(client:didLoadImage:key:error:)];
    [sInvocation setArgument:&self atIndex:2];
    [sInvocation setArgument:&sImage atIndex:3];
    [sInvocation setArgument:&sKey atIndex:4];
    [sInvocation setArgument:&sError atIndex:5];
    [sInvocation invokeWithTarget:sDelegate];

    for (sContext in [gQueuedOperations objectForKey:sURL])
    {
        sKey = [sContext objectForKey:@"key"];
        [sInvocation setArgument:&sKey atIndex:4];
        [sInvocation invokeWithTarget:[sContext objectForKey:@"delegate"]];
    }

    [gQueuedOperations removeObjectForKey:sURL];
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


- (void)clientOperation:(MEClientOperation *)aOperation didReceiveCreateCommentResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [aOperation context];

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
            NSError *sError = [self errorFromResultDictionary:sResult];

            if (sError)
            {
                [sDelegate client:self didCreatePostWithError:sError];
            }
            else
            {
                [sDelegate client:self didCreatePostWithError:nil];
            }
        }
        else
        {
            [sDelegate client:self didCreatePostWithError:[self errorFromResultString:sSource]];
        }

        [sPool release];
    }
}


- (void)clientOperation:(MEClientOperation *)aOperation didReceiveGetCommentsResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [aOperation context];

    if (aError)
    {
        [sDelegate client:self didGetComments:nil error:aError];
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
                [sDelegate client:self didGetComments:nil error:sError];
            }
            else
            {
                NSMutableArray *sComments = [NSMutableArray array];
                NSDictionary   *sDict;

                for (sDict in [sResult objectForKey:@"comments"])
                {
                    [sComments addObject:[[[MEComment alloc] initWithDictionary:sDict] autorelease]];
                }

                [sDelegate client:self didGetComments:sComments error:nil];
            }
        }
        else
        {
            [sDelegate client:self didGetComments:nil error:[self errorFromResultString:sSource]];
        }

        [sPool release];
    }
}


- (void)clientOperation:(MEClientOperation *)aOperation didReceiveGetFriendsResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [aOperation context];

    if (aError)
    {
        [sDelegate client:self didGetFriends:nil error:aError];
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
                [sDelegate client:self didGetFriends:nil error:sError];
            }
            else
            {
                NSMutableArray *sUsers = [NSMutableArray array];
                NSDictionary   *sDict;

                for (sDict in [sResult objectForKey:@"friends"])
                {
                    [sUsers addObject:[[[MEUser alloc] initWithDictionary:sDict] autorelease]];
                }

                [sDelegate client:self didGetFriends:sUsers error:nil];
            }
        }
        else
        {
            [sDelegate client:self didGetFriends:nil error:[self errorFromResultString:sSource]];
        }

        [sPool release];
    }
}


- (void)clientOperation:(MEClientOperation *)aOperation didReceiveGetMetoosResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [aOperation context];

    if (aError)
    {
        [sDelegate client:self didGetMetoos:nil error:aError];
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
                [sDelegate client:self didGetMetoos:nil error:sError];
            }
            else
            {
                NSMutableArray *sUsers = [NSMutableArray array];
                NSDictionary   *sDict;

                for (sDict in [sResult objectForKey:@"metoos"])
                {
                    [sUsers addObject:[[[MEUser alloc] initWithDictionary:[sDict objectForKey:@"author"]] autorelease]];
                }

                [sDelegate client:self didGetMetoos:sUsers error:nil];
            }
        }
        else
        {
            [sDelegate client:self didGetMetoos:nil error:[self errorFromResultString:sSource]];
        }

        [sPool release];
    }
}


- (void)clientOperation:(MEClientOperation *)aOperation didReceiveGetPersonResult:(NSData *)aData error:(NSError *)aError
{
    NSURL        *sURL        = [[aOperation context] objectForKey:@"url"];
    id            sDelegate   = [[aOperation context] objectForKey:@"delegate"];
    NSInvocation *sInvocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@:@@@"]];
    MEUser       *sUser       = nil;
    NSError      *sError      = nil;
    NSDictionary *sContext;

    if (aError)
    {
        sError = aError;
    }
    else
    {
        NSAutoreleasePool *sPool   = [[NSAutoreleasePool alloc] init];
        NSString          *sSource = [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary      *sResult = [sSource JSONValue];

        if (sResult)
        {
            sError = [[self errorFromResultDictionary:sResult] retain];

            if (!sError)
            {
                sUser = [[MEUser alloc] initWithDictionary:sResult];
            }
        }
        else
        {
            sError = [[self errorFromResultString:sSource] retain];
        }

        [sPool release];
        [sUser autorelease];
        [sError autorelease];
    }

    [sInvocation setSelector:@selector(client:didGetPerson:error:)];
    [sInvocation setArgument:&self atIndex:2];
    [sInvocation setArgument:&sUser atIndex:3];
    [sInvocation setArgument:&sError atIndex:4];
    [sInvocation invokeWithTarget:sDelegate];

    for (sContext in [gQueuedOperations objectForKey:sURL])
    {
        [sInvocation invokeWithTarget:[sContext objectForKey:@"delegate"]];
    }

    [gQueuedOperations removeObjectForKey:sURL];
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
        id                 sResult = [sSource JSONValue];

        if (sResult)
        {
            if ([sResult isKindOfClass:[NSArray class]])
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
                NSError *sError = [self errorFromResultDictionary:sResult];

                if (sError)
                {
                    [sDelegate client:self didGetPosts:nil error:sError];
                }
                else
                {
                    [sDelegate client:self didGetPosts:nil error:[self errorFromResultString:@"Unexpected response from server."]];
                }
            }
        }
        else
        {
            [sDelegate client:self didGetPosts:nil error:[self errorFromResultString:sSource]];
        }

        [sPool release];
    }
}


- (void)clientOperation:(MEClientOperation *)aOperation didReceiveMetooResult:(NSData *)aData error:(NSError *)aError
{
    id sDelegate = [aOperation context];

    if (aError)
    {
        [sDelegate client:self didMetooWithError:aError];
    }
    else
    {
        NSAutoreleasePool *sPool   = [[NSAutoreleasePool alloc] init];
        NSString          *sSource = [[[NSString alloc] initWithData:aData encoding:NSUTF8StringEncoding] autorelease];
        NSDictionary      *sResult = [sSource JSONValue];

        if (sResult)
        {
            NSError *sError = [self errorFromResultDictionary:sResult];

            if (sError)
            {
                [sDelegate client:self didMetooWithError:sError];
            }
            else
            {
                [sDelegate client:self didMetooWithError:nil];
            }
        }
        else
        {
            [sDelegate client:self didMetooWithError:[self errorFromResultString:sSource]];
        }

        [sPool release];
    }
}


@end
