/*
 *  MEPost.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSURL+MEAdditions.h"
#import "MEPost.h"
#import "MEFuture.h"
#import "MEClientStore.h"
#import "MEClient.h"


@interface MEPost (DateFormatting)
@end

@implementation MEPost (DateFormatting)

- (NSDate *)dateFromString:(NSString *)aDateString
{
    static NSDateFormatter *sDateFormatter = nil;

    if (!sDateFormatter)
    {
        sDateFormatter = [[NSDateFormatter alloc] init];
        [sDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    }

    return [sDateFormatter dateFromString:aDateString];
}

@end


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
        mBody          = [[aPostDict objectForKey:@"body"] retain];
        mKind          = [[aPostDict objectForKey:@"kind"] retain];
        mPubDate       = [[self dateFromString:[aPostDict objectForKey:@"pubDate"]] retain];
        mCommentsCount = [[aPostDict objectForKey:@"commentsCount"] integerValue];
        mMetooCount    = [[aPostDict objectForKey:@"metooCount"] integerValue];
        mUser          = [[MEUser alloc] initWithDictionary:[aPostDict objectForKey:@"author"]];
        mTags          = [[[aPostDict objectForKey:@"tags"] valueForKey:@"name"] retain];
        mIconURL       = [[NSURL alloc] initWithStringOrNil:[aPostDict objectForKey:@"iconUrl"]];
        mPhotoURL      = [[NSURL alloc] initWithStringOrNil:[[aPostDict objectForKey:@"media"] objectForKey:@"photoUrl"]];

        if (!mIconURL)
        {
            mIconURL = [[NSURL alloc] initWithStringOrNil:[aPostDict objectForKey:@"icon"]];
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
    [mUser     release];
    [mTags     release];
    [mIconURL  release];
    [mPhotoURL release];

    [super dealloc];
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
