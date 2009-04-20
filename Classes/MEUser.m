/*
 *  MEUser.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEUser.h"


@implementation MEUser


#pragma mark -
#pragma mark properties


@synthesize userID         = mUserID;
@synthesize nickname       = mNickname;
@synthesize faceImage      = mFaceImage;
@synthesize homepageURLStr = mHomepageURLStr;


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
    [mUserID         release];
    [mNickname       release];
    [mFaceImage      release];
    [mHomepageURLStr release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


- (void)downloadFaceImage:(NSURL *)aFaceImageURL
{

}


@end
