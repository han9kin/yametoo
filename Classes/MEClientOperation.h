/*
 *  MEClientOperation.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


/*
 * delegate method signature:
 *  - (void)clientOperation:(MEClientOperation *)aOperation data:(NSData *)aData error:(NSError *)aError
 */

@interface MEClientOperation : NSOperation
{
    NSURLConnection *mConnection;
    NSMutableData   *mData;

    id               mDelegate;
    SEL              mSelector;
    id               mContext;
    BOOL             mContextRetained;

    BOOL             mExecuting;
    BOOL             mFinished;
}

@property(nonatomic, assign) id  delegate;
@property(nonatomic, assign) SEL selector;
@property(nonatomic, assign) id  context;


- (void)setRequest:(NSMutableURLRequest *)aRequest;

- (BOOL)contextRetained;
- (void)retainContext;

@end
