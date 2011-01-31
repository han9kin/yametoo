/*
 *  MEBookmark.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 21.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MEBookmark.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"
#import "MEPost.h"


@interface MEBookmark (Private)
@end

@implementation MEBookmark (Private)

- (void)setupTitleWithUser:(MEUser *)aUser
{
    static NSDateFormatter *sDateFormatter = nil;

    if (!sDateFormatter)
    {
        sDateFormatter = [[NSDateFormatter alloc] init];

        [sDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    }

    NSString *sName = aUser ? [aUser nickname] : mUserID;

    [mTitle release];

    if (mPostID)
    {
        mTitle = [[NSString alloc] initWithFormat:@"%@ (%@)", [NSString stringWithFormat:NSLocalizedString(@"%@'s Post", @""), sName], [sDateFormatter stringFromDate:mPostDate]];
    }
    else
    {
        mTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@'s me2DAY", @""), sName];
    }
}

@end


@implementation MEBookmark

@synthesize userID = mUserID;
@synthesize postID = mPostID;
@dynamic    title;


- (id)initWithUserID:(NSString *)aUserID
{
    self = [super init];

    if (self)
    {
        mUserID = [aUserID copy];
    }

    return self;
}

- (id)initWithUser:(MEUser *)aUser
{
    self = [super init];

    if (self)
    {
        mUserID = [[aUser userID] copy];

        [self setupTitleWithUser:aUser];
    }

    return self;
}

- (id)initWithPostID:(NSString *)aPostID
{
    self = [super init];

    if (self)
    {
        mPostID = [aPostID copy];
    }

    return self;
}

- (id)initWithPost:(MEPost *)aPost
{
    self = [super init];

    if (self)
    {
        mUserID   = [[[aPost author] userID] copy];
        mPostID   = [[aPost postID] copy];
        mPostDate = [[aPost pubDate] copy];

        [self setupTitleWithUser:[aPost author]];
    }

    return self;
}

- (void)dealloc
{
    [mUserID release];
    [mPostID release];
    [mPostDate release];
    [mTitle release];
    [super dealloc];
}


#pragma mark -
#pragma mark NSCoding


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];

    if (self)
    {
        mUserID   = [[aCoder decodeObjectForKey:@"userID"] retain];
        mPostID   = [[aCoder decodeObjectForKey:@"postID"] retain];
        mPostDate = [[aCoder decodeObjectForKey:@"postDate"] retain];
    }

    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:mUserID forKey:@"userID"];
    [aCoder encodeObject:mPostID forKey:@"postID"];
    [aCoder encodeObject:mPostDate forKey:@"postDate"];
}


#pragma mark -
#pragma mark Identifying


- (BOOL)isEqual:(id)aObject
{
    if (self == aObject)
    {
        return YES;
    }
    else if ([aObject isKindOfClass:[self class]])
    {
        if (mPostID && [aObject postID])
        {
            return [mPostID isEqualToString:[aObject postID]];
        }
        else if (!mPostID && ![aObject postID])
        {
            return [mUserID isEqualToString:[aObject userID]];
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

- (NSUInteger)hash
{
    if (mPostID)
    {
        return [mPostID hash] ^ [mUserID hash];
    }
    else
    {
        return [mUserID hash];
    }
}


#pragma mark -
#pragma mark dynamic properties


- (NSString *)title
{
    if (!mTitle)
    {
        MEUser *sUser = [MEUser userWithUserID:mUserID];

        [self setupTitleWithUser:sUser];

        if (!sUser)
        {
            [[MEClientStore currentClient] getPersonWithUserID:mUserID delegate:self];
        }
    }

    return mTitle;
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    if (aUser)
    {
        [self willChangeValueForKey:@"title"];
        [self setupTitleWithUser:aUser];
        [self didChangeValueForKey:@"title"];
    }
}


@end
