/*
 *  MEClientOperation.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 15.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MEClientOperation.h"
#import "MEClient.h"


static NSString *gUserAgent = nil;


@implementation MEClientOperation

@synthesize runLoopThread    = mRunLoopThread;
@synthesize delegate         = mDelegate;
@synthesize selector         = mSelector;
@synthesize context          = mContext;
@synthesize progressDelegate = mProgressDelegate;


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

    [mRunLoopThread release];
    [mConnection release];
    [mData release];
    [super dealloc];
}


#pragma mark -
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
    NSThread *sRunLoopThread = mRunLoopThread ? mRunLoopThread : [NSThread mainThread];

    if (sRunLoopThread != [NSThread currentThread])
    {
        [self performSelector:_cmd onThread:sRunLoopThread withObject:nil waitUntilDone:NO];
        return;
    }

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
        [MEClient beginNetworkOperation];
    }
}


#pragma mark -
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

        [MEClient endNetworkOperation];
    }
}


#pragma mark -
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


#pragma mark -
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

    if ((sLength == NSURLResponseUnknownLength) || (sLength > NSUIntegerMax))
    {
        mExpectedLength = 0;
    }
    else
    {
        mExpectedLength = sLength;
    }

    [mData release];
    mData = [[NSMutableData alloc] initWithCapacity:mExpectedLength];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)aData
{
    [mData appendData:aData];

    if (mExpectedLength && [mProgressDelegate respondsToSelector:@selector(clientOperation:didReceiveDataProgress:)])
    {
        [mProgressDelegate clientOperation:self didReceiveDataProgress:((float)[mData length] / mExpectedLength)];
    }
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

- (void)connection:(NSURLConnection *)aConnection didSendBodyData:(NSInteger)aBytesWritten totalBytesWritten:(NSInteger)aTotalBytesWritten totalBytesExpectedToWrite:(NSInteger)aTotalBytesExpectedToWrite
{
    if ([mProgressDelegate respondsToSelector:@selector(clientOperation:didSendDataProgress:)])
    {
        [mProgressDelegate clientOperation:self didSendDataProgress:((float)aTotalBytesWritten / aTotalBytesExpectedToWrite)];
    }
}


@end
