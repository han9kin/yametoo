/*
 *  MEPost.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEPost.h"


@implementation MEPost


#pragma mark -
#pragma mark properties


@synthesize postID = mPostID;
@synthesize body   = mBody;
@synthesize kind   = mKind;


#pragma mark -
#pragma mark init/dealloc


- (void)dealloc
{
    [mPostID  release];
    [mBody    release];
    [mKind    release];
    [mPubDate release];
    [mUser    release];
    
    [mMe2PhotoImage release];
    [mKindIconImage release];
    [mTagArray      release];
    
    [super dealloc];
}


@end
