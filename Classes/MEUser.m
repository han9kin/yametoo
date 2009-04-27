/*
 *  MEUser.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSURL+MEAdditions.h"
#import "MEUser.h"
#import "MEFuture.h"
#import "MEClientStore.h"
#import "MEClient.h"


static NSMutableDictionary *gCachedUsers = nil;


@interface MEUser (Private)
@end

@implementation MEUser (Private)

- (void)setNickname:(NSString *)aNickName
{
    if (![mNickname isEqualToString:aNickName])
    {
        [mNickname release];
        mNickname = [aNickName retain];
    }
}

- (void)setFaceImageURL:(NSURL *)aFaceImageURL
{
    if (![mFaceImageURL isEqual:aFaceImageURL])
    {
        [mFaceImageURL release];
        mFaceImageURL = [aFaceImageURL retain];
    }
}

@end


@implementation MEUser


#pragma mark -
#pragma mark properties


@synthesize userID         = mUserID;
@synthesize nickname       = mNickname;
@synthesize faceImageURL   = mFaceImageURL;
@synthesize homepageURLStr = mHomepageURLStr;


#pragma mark -
#pragma mark cache control


+ (void)removeUnusedCachedUsers
{
    MEUser *sUser;

    for (sUser in [gCachedUsers allValues])
    {
        if (([sUser retainCount] == 1) && ![[MEClientStore userIDs] containsObject:[sUser userID]])
        {
            [gCachedUsers removeObjectForKey:[sUser userID]];
        }
    }
}


+ (MEUser *)userWithUserID:(NSString *)aUserID
{
    return [gCachedUsers objectForKey:aUserID];
}


#pragma mark -
#pragma mark init/dealloc


+ (void)initialize
{
    if (!gCachedUsers)
    {
        gCachedUsers = [[NSMutableDictionary alloc] init];
    }
}


- (id)initWithDictionary:(NSDictionary *)aUserDict
{
    self = [super init];

    if (self)
    {
        mUserID = [[aUserDict objectForKey:@"id"] retain];

        MEUser *sUser = [gCachedUsers objectForKey:mUserID];

        if (sUser)
        {
            [self release];
            self = [sUser retain];
        }
        else
        {
            [gCachedUsers setObject:self forKey:mUserID];
        }

        [self setNickname:[aUserDict objectForKey:@"nickname"]];
        [self setFaceImageURL:[NSURL URLWithStringOrNil:[aUserDict objectForKey:@"face"]]];
    }

    return self;
}


- (void)dealloc
{
    [mUserID         release];
    [mNickname       release];
    [mFaceImageURL   release];
    [mHomepageURLStr release];

    [super dealloc];
}


@end
