/*
 *  MEClientOperation.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MEClientOperation : NSOperation
{
    NSURLConnection *mConnection;
    NSMutableData   *mData;

    id               mContext;
    id               mDelegate;
    SEL              mSelector;

    BOOL             mExecuting;
    BOOL             mFinished;
}

@property(nonatomic, retain) id  context;
@property(nonatomic, assign) id  delegate;
@property(nonatomic, assign) SEL selector;


- (void)setRequet:(NSMutableURLRequest *)aRequest;


@end
