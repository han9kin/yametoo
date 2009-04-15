/*
 *  MEClient.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEClient.h"
#import "NSString+MEAdditions.h"


@implementation MEClient


#pragma mark - properties


@synthesize nonce   = mNonce;
@synthesize appKey  = mAppKey;
@synthesize userKey = mUserKey;
@synthesize userID  = mUserID;


#pragma mark - init/dealloc


- (id)init
{
    self = [super init];
    if (self)
    {
        mBaseURL = [[NSString alloc] initWithString:@"http://me2day.net/api/"];
        mNonce   = [[NSString alloc] initWithString:@"1A3D485B"];
        mAppKey  = [[NSString alloc] initWithString:@"e9a4f3c223bba69df0b1347d755b8c38"];
    }
    
    return self;
}


- (void)dealloc
{
    [mBaseURL release];
    [mNonce   release];
    [mAppKey  release];
    [mUserKey release];
    [mUserID  release];
    
    [super dealloc];
}


#pragma mark -


- (NSString *)authKey
{
    return [NSString stringWithFormat:@"%@%@", mNonce, [[NSString stringWithFormat:@"%@%@", mNonce, mUserKey] md5String]];
}


@end
