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


@synthesize postID        = mPostID;
@synthesize body          = mBody;
@synthesize kind          = mKind;
@synthesize pubDate       = mPubDate;
@synthesize commentsCount = mCommentsCount;
@synthesize metooCount    = mMetooCount;
@synthesize user          = mUser;
@synthesize tags          = mTagArray;


#pragma mark -
#pragma mark init/dealloc


- (id)init
{
    self = [super init];
    if (self)
    {

    }
    
    return self;
}


- (void)dealloc
{
    [mPostID   release];
    [mBody     release];
    [mKind     release];
    [mPubDate  release];
    [mUser     release];
    [mTagArray release];
    
    [mMe2PhotoImage release];
    [mKindIconImage release];

    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)downloadMe2PhotoImageWithURL:(NSURL *)aURL
{

}


- (void)downloadKindIconImageWithURL:(NSURL *)aURL
{

}


@end
