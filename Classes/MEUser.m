/*
 *  MEUser.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

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
        [mFaceImage release];
        mFaceImageURL = [aFaceImageURL retain];

        if (mFaceImageURL)
        {
            [self willChangeValueForKey:@"faceImage"];
            [mFaceImageURL release];
            mFaceImage = nil;
            [self didChangeValueForKey:@"faceImage"];
        }
    }
}

@end


@implementation MEUser


#pragma mark -
#pragma mark properties


@synthesize userID         = mUserID;
@synthesize nickname       = mNickname;
@synthesize homepageURLStr = mHomepageURLStr;
@dynamic    faceImage;


#pragma mark -
#pragma mark cache control

+ (void)removeUnusedCachedUsers
{
    NSMutableArray *sUserIDs = [[NSMutableArray alloc] init];
    id              sObj;

    for (sObj in [gCachedUsers allValues])
    {
        if ([sObj retainCount] == 1)
        {
            [sUserIDs addObject:[sObj userID]];
        }
    }

    for (sObj in sUserIDs)
    {
        [gCachedUsers removeObjectForKey:sObj];
    }
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
            self = sUser;
        }

        [self setNickname:[aUserDict objectForKey:@"nickname"]];
        [self setFaceImageURL:[NSURL URLWithString:[aUserDict objectForKey:@"face"]]];
    }

    return self;
}


- (void)dealloc
{
    [mUserID         release];
    [mNickname       release];
    [mFaceImageURL   release];
    [mHomepageURLStr release];

    [mFaceImage      release];

    [super dealloc];
}


#pragma mark -
#pragma mark dynamic property accessor


- (UIImage *)faceImage
{
    if (!mFaceImage)
    {
        if (mFaceImageURL)
        {
            mFaceImage = [MEFuture future];
            [[MEClientStore currentClient] loadImageWithURL:mFaceImageURL key:nil shouldCache:YES delegate:self];
        }
    }

    return mFaceImage;
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didLoadImage:(UIImage *)aImage error:(NSError *)aError
{
    if (mFaceImage != aImage)
    {
        [self willChangeValueForKey:@"faceImage"];
        [mFaceImage release];
        mFaceImage = [aImage retain];
        [self didChangeValueForKey:@"faceImage"];
    }
}


@end
