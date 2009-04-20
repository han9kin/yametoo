/*
 *  MEClientOperation.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEClientOperation.h"


static NSString *gUserAgent              = nil;
static int       gNetworkOperationsCount = 0;


@interface MEClientOperation (NetworkActivityIndicating)
@end

@implementation MEClientOperation (NetworkActivityIndicating)

+ (void)beginNetworkOperation
{
    if (gNetworkOperationsCount == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }

    gNetworkOperationsCount++;
}

+ (void)endNetworkOperation
{
    gNetworkOperationsCount--;

    if (gNetworkOperationsCount == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end


@implementation MEClientOperation

@synthesize delegate = mDelegate;
@synthesize selector = mSelector;
@synthesize context  = mContext;


+ (void)initialize
{
    if (!gUserAgent)
    {
        UIDevice     *sDevice = [UIDevice currentDevice];
        NSDictionary *sInfo   = [[NSBundle mainBundle] infoDictionary];

        gUserAgent = [[NSString alloc] initWithFormat:@"%@/%@ (%@; %@ %@)", [sInfo objectForKey:(id)kCFBundleNameKey], [sInfo objectForKey:(id)kCFBundleVersionKey], [sDevice model], [sDevice systemName], [sDevice systemVersion]];
    }
}

- (void)dealloc
{
    if (mContextRetained)
    {
        [mContext release];
    }
    [mConnection release];
    [mData release];
    [super dealloc];
}


#pragma mark overrides for concurrent operation

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return mExecuting;
}

- (BOOL)isFinished
{
    return mFinished;
}

- (void)start
{
    if ([self isCancelled])
    {
        [self willChangeValueForKey:@"isFinished"];
        mFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
    else
    {
        [self willChangeValueForKey:@"isExecuting"];
        mExecuting  = YES;
        [self didChangeValueForKey:@"isExecuting"];

        [mConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [mConnection start];

        [MEClientOperation beginNetworkOperation];
    }
}


#pragma mark controlling operation

- (void)cancel
{
    [super cancel];

    if ([self isExecuting])
    {
        [mConnection cancel];

        [self performSelector:@selector(stop) withObject:nil afterDelay:0];
    }
}

- (void)stop
{
    if ([self isExecuting])
    {
        [self willChangeValueForKey:@"isFinished"];
        [self willChangeValueForKey:@"isExecuting"];
        mExecuting = NO;
        mFinished  = YES;
        [self didChangeValueForKey:@"isExecuting"];
        [self didChangeValueForKey:@"isFinished"];

        [MEClientOperation endNetworkOperation];
    }
}


#pragma mark setting operation

- (void)setRequest:(NSMutableURLRequest *)aRequest
{
    [aRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [aRequest setValue:gUserAgent forHTTPHeaderField:@"User-Agent"];

    mConnection = [[NSURLConnection alloc] initWithRequest:aRequest delegate:self startImmediately:NO];
}

- (BOOL)contextRetained
{
    return mContextRetained;
}

- (void)retainContext
{
    if (!mContextRetained)
    {
        [mContext retain];
        mContextRetained = YES;
    }
}

#pragma mark NSURLConnectionDelegate

- (NSCachedURLResponse *)connection:(NSURLConnection *)aConnection willCacheResponse:(NSCachedURLResponse *)aCachedResponse
{
    return nil;
}

- (NSURLRequest *)connection:(NSURLConnection *)aConnection willSendRequest:(NSURLRequest *)aRequest redirectResponse:(NSURLResponse *)aRedirectResponse
{
    NSMutableURLRequest *sRequest;

    sRequest = [aRequest mutableCopy];
    [sRequest setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [sRequest setValue:gUserAgent forHTTPHeaderField:@"User-Agent"];

    return [sRequest autorelease];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
    long long sLength = [aResponse expectedContentLength];

    if (sLength == NSURLResponseUnknownLength)
    {
        sLength = 0;
    }

    [mData release];
    mData = [[NSMutableData alloc] initWithCapacity:sLength];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)aData
{
    [mData appendData:aData];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)aError
{
    id            sNil;
    NSInvocation *sInvocation;

    if (![self isCancelled])
    {
        sNil        = nil;
        sInvocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@:@@@"]];

        [sInvocation setTarget:mDelegate];
        [sInvocation setSelector:mSelector];
        [sInvocation setArgument:&self atIndex:2];
        [sInvocation setArgument:&sNil atIndex:3];
        [sInvocation setArgument:&aError atIndex:4];

        [sInvocation invoke];
    }

    [self stop];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    id            sNil;
    NSInvocation *sInvocation;

    if (![self isCancelled])
    {
        sNil = nil;
        sInvocation = [NSInvocation invocationWithMethodSignature:[NSMethodSignature signatureWithObjCTypes:"v@:@@@"]];

        [sInvocation setTarget:mDelegate];
        [sInvocation setSelector:mSelector];
        [sInvocation setArgument:&self atIndex:2];
        [sInvocation setArgument:&mData atIndex:3];
        [sInvocation setArgument:&sNil atIndex:4];

        [sInvocation invoke];
    }

    [self stop];
}

@end
