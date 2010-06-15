/*
 *  MEClientOperation.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@class MEClientOperation;

@protocol MEClientOperationDelegate

/*
 * Delegate
 */

- (void)clientOperation:(MEClientOperation *)aOperation data:(NSData *)aData error:(NSError *)aError;

/*
 * Progress Delegate
 */

- (void)clientOperation:(MEClientOperation *)aOperation didSendDataProgress:(float)aProgress;
- (void)clientOperation:(MEClientOperation *)aOperation didReceiveDataProgress:(float)aProgress;

@end


@interface MEClientOperation : NSOperation
{
    NSThread        *mRunLoopThread;
    NSURLConnection *mConnection;
    NSMutableData   *mData;

    id               mDelegate;
    SEL              mSelector;
    id               mContext;
    BOOL             mContextRetained;

    id               mProgressDelegate;
    NSUInteger       mExpectedLength;

    BOOL             mExecuting;
    BOOL             mFinished;
}

@property(nonatomic, retain) NSThread *runLoopThread;
@property(nonatomic, assign) id  delegate;
@property(nonatomic, assign) SEL selector;
@property(nonatomic, assign) id  context;
@property(nonatomic, assign) id  progressDelegate;


- (void)setRequest:(NSMutableURLRequest *)aRequest;

- (BOOL)contextRetained;
- (void)retainContext;


@end
