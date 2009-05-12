/*
 *  MEPost.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSDate+MEAdditions.h"
#import "NSURL+MEAdditions.h"
#import "MEPost.h"
#import "MEUser.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEPostBodyTextParser.h"


@implementation MEPost


#pragma mark -
#pragma mark properties


@synthesize postID        = mPostID;
@synthesize body          = mBody;
@synthesize kind          = mKind;
@synthesize pubDate       = mPubDate;
@synthesize commentsCount = mCommentsCount;
@synthesize metooCount    = mMetooCount;
@synthesize author        = mAuthor;
@synthesize tags          = mTags;
@synthesize iconURL       = mIconURL;
@synthesize photoURL      = mPhotoURL;
@dynamic    tagsString;
@dynamic    pubTimeString;


#pragma mark -
#pragma mark init/dealloc


- (id)initWithDictionary:(NSDictionary *)aPostDict
{
    self = [super init];

    if (self)
    {
        mPostID        = [[aPostDict objectForKey:@"post_id"] retain];
        mBody          = [[MEPostBodyTextParser attributedStringFromString:[aPostDict objectForKey:@"body"]] retain];
        mKind          = [[aPostDict objectForKey:@"kind"] retain];
        mPubDate       = [[NSDate dateFromISO8601:[aPostDict objectForKey:@"pubDate"]] retain];
        mCommentsCount = [[aPostDict objectForKey:@"commentsCount"] integerValue];
        mMetooCount    = [[aPostDict objectForKey:@"metooCount"] integerValue];
        mAuthor        = [[MEUser userWithUserID:[[aPostDict objectForKey:@"author"] objectForKey:@"id"]] retain];
        mTags          = [[[aPostDict objectForKey:@"tags"] valueForKey:@"name"] retain];
        mIconURL       = [[NSURL alloc] initWithStringOrNil:[aPostDict objectForKey:@"iconUrl"]];
        mPhotoURL      = [[NSURL alloc] initWithStringOrNil:[[aPostDict objectForKey:@"media"] objectForKey:@"photoUrl"]];

        if (!mIconURL)
        {
            mIconURL = [[NSURL alloc] initWithStringOrNil:[aPostDict objectForKey:@"icon"]];
        }

        if (!mAuthor)
        {
            mAuthor = [[MEUser alloc] initWithDictionary:[aPostDict objectForKey:@"author"]];
        }
    }

    return self;
}


- (void)dealloc
{
    [mPostID   release];
    [mBody     release];
    [mKind     release];
    [mPubDate  release];
    [mAuthor   release];
    [mTags     release];
    [mIconURL  release];
    [mPhotoURL release];

    [super dealloc];
}


#pragma mark -
#pragma mark Identifying and Comparing Objects


- (BOOL)isEqual:(id)aObject
{
    if ([aObject isKindOfClass:[MEPost class]])
    {
        return [mPostID isEqualToString:[(MEPost *)aObject postID]];
    }
    else
    {
        return NO;
    }
}


- (NSUInteger)hash
{
    return [mPostID hash];
}


#pragma mark -
#pragma mark dynamic property accessors


- (NSString *)tagsString
{
    return [mTags componentsJoinedByString:@" "];
}


- (NSString *)pubTimeString
{
    static NSDateFormatter *sDateFormatter = nil;

    if (!sDateFormatter)
    {
        sDateFormatter = [[NSDateFormatter alloc] init];
        [sDateFormatter setLocale:[NSLocale currentLocale]];

        if ([[[NSLocale currentLocale] localeIdentifier] hasPrefix:@"ko"])
        {
            [sDateFormatter setDateFormat:NSLocalizedString(@"h':'mm a", @"")];
        }
        else
        {
            [sDateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
    }

    return [sDateFormatter stringFromDate:mPubDate];
}


@end
