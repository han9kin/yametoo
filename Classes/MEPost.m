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
#import "MEAttributedString.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MELink.h"
#import "MEPost.h"
#import "MEUser.h"
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
@dynamic    links;
@synthesize commentClosed = mCommentClosed;


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
        mTags          = [[[[aPostDict objectForKey:@"tags"] valueForKey:@"name"] componentsJoinedByString:@" "] retain];
        mIconURL       = [[NSURL alloc] initWithStringOrNil:[aPostDict objectForKey:@"iconUrl"]];
        mPhotoURL      = [[NSURL alloc] initWithStringOrNil:[[aPostDict objectForKey:@"media"] objectForKey:@"photoUrl"]];
        mCommentClosed = [[aPostDict objectForKey:@"commentClosed"] boolValue];

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
    [mPostID release];
    [mBody release];
    [mKind release];
    [mPubDate release];
    [mAuthor release];
    [mTags release];
    [mIconURL release];
    [mPhotoURL release];
    [mLinks release];
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


- (NSArray *)links
{
    if (!mLinks)
    {
        MELink     *sLink;
        NSString   *sCurrURL;
        NSString   *sLastURL;
        NSRange     sCurrRange;
        NSRange     sLastRange;
        NSUInteger  sIndex;
        NSUInteger  sLength;

        sLastURL = nil;
        sLength  = [mBody length];

        for (sIndex = 0; sIndex < sLength; sIndex = NSMaxRange(sCurrRange))
        {
            sCurrURL = [mBody attribute:MELinkAttributeName atIndex:sIndex effectiveRange:&sCurrRange];

            if (sCurrURL)
            {
                if ([sCurrURL isEqual:sLastURL] && (NSMaxRange(sLastRange) == sCurrRange.location))
                {
                    [[mLinks lastObject] appendTitle:[[mBody string] substringWithRange:sCurrRange]];
                }
                else
                {
                    if (!mLinks)
                    {
                        mLinks = [[NSMutableArray alloc] init];
                    }

                    sLink = [[MELink alloc] initWithURL:sCurrURL title:[[mBody string] substringWithRange:sCurrRange]];
                    [mLinks addObject:sLink];
                    [sLink release];
                }

                sLastURL   = sCurrURL;
                sLastRange = sCurrRange;
            }
        }
    }

    return mLinks;
}


@end
