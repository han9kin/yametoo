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
#import "MEPostIcon.h"
#import "MEClientStore.h"
#import "MEClient.h"


static NSMutableDictionary *gCachedUsers = nil;


@interface MEUser (Private)
@end

@implementation MEUser (Private)

- (void)setNickname:(NSString *)aNickname
{
    if (aNickname && ![mNickname isEqualToString:aNickname])
    {
        [mNickname release];
        mNickname = [aNickname retain];
    }
}

- (void)setFaceImageURL:(NSURL *)aFaceImageURL
{
    if (aFaceImageURL && ![mFaceImageURL isEqual:aFaceImageURL])
    {
        [mFaceImageURL release];
        mFaceImageURL = [aFaceImageURL retain];
    }
}

- (void)setUserDescription:(NSString *)aUserDescription
{
    if (aUserDescription && ![mUserDescription isEqualToString:aUserDescription])
    {
        [mUserDescription release];
        mUserDescription = [aUserDescription retain];
    }
}

- (void)setHomepageURLString:(NSString *)aHomepageURLString
{
    if (aHomepageURLString && ![mHomepageURLString isEqualToString:aHomepageURLString])
    {
        [mHomepageURLString release];
        mHomepageURLString = [aHomepageURLString retain];
    }
}

- (void)setPhoneNumber:(NSString *)aPhoneNumber
{
    if (aPhoneNumber && ![mPhoneNumber isEqualToString:aPhoneNumber])
    {
        [mPhoneNumber release];
        mPhoneNumber = [aPhoneNumber retain];
    }
}

- (void)setEmail:(NSString *)aEmail
{
    if (aEmail && ![mEmail isEqualToString:aEmail])
    {
        [mEmail release];
        mEmail = [aEmail retain];
    }
}

- (void)setMessenger:(NSString *)aMessenger
{
    if (aMessenger && ![mMessenger isEqualToString:aMessenger])
    {
        [mMessenger release];
        mMessenger = [aMessenger retain];
    }
}

- (void)setPostIcons:(NSArray *)aPostIcons
{
    if (aPostIcons && ![mPostIcons isEqualToArray:aPostIcons])
    {
        [mPostIcons release];
        mPostIcons = [aPostIcons retain];
    }
}

@end


@implementation MEUser


#pragma mark -
#pragma mark properties


@synthesize userID            = mUserID;
@synthesize nickname          = mNickname;
@synthesize faceImageURL      = mFaceImageURL;
@synthesize userDescription   = mUserDescription;
@synthesize homepageURLString = mHomepageURLString;
@synthesize phoneNumber       = mPhoneNumber;
@synthesize email             = mEmail;
@synthesize messenger         = mMessenger;
@synthesize postIcons         = mPostIcons;


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


+ (MEUser *)currentUser
{
    return [gCachedUsers objectForKey:[[MEClientStore currentClient] userID]];
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
        [self setUserDescription:[aUserDict objectForKey:@"description"]];
        [self setHomepageURLString:[aUserDict objectForKey:@"homepage"]];
        [self setPhoneNumber:[aUserDict objectForKey:@"cellphone"]];
        [self setEmail:[aUserDict objectForKey:@"email"]];
        [self setMessenger:[aUserDict objectForKey:@"messenger"]];

        if ([aUserDict objectForKey:@"postIcons"] && [[MEClientStore userIDs] containsObject:mUserID])
        {
            NSMutableArray *sPostIcons = [NSMutableArray array];
            NSDictionary   *sDict;

            for (sDict in [aUserDict objectForKey:@"postIcons"])
            {
                [sPostIcons addObject:[[[MEPostIcon alloc] initWithDictionary:sDict] autorelease]];
            }

            [self setPostIcons:sPostIcons];
        }
    }

    return self;
}


- (void)dealloc
{
    [mUserID release];
    [mNickname release];
    [mFaceImageURL release];
    [mUserDescription release];
    [mHomepageURLString release];
    [mPhoneNumber release];
    [mEmail release];
    [mMessenger release];
    [mPostIcons release];

    [super dealloc];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p userID=%@ nickname=%@>", NSStringFromClass([self class]), self, mUserID, mNickname];
}


@end
