/*
 *  MEComment.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSDate+MEAdditions.h"
#import "MEAttributedString.h"
#import "MELink.h"
#import "MEComment.h"
#import "MECommentBodyTextParser.h"
#import "MEUser.h"


@implementation MEComment

@synthesize commentID = mCommentID;
@synthesize body      = mBody;
@synthesize pubDate   = mPubDate;
@synthesize author    = mAuthor;


- (id)initWithDictionary:(NSDictionary *)aCommentDict
{
    self = [super init];

    if (self)
    {
        mCommentID = [[aCommentDict objectForKey:@"commentId"] retain];
        mBody      = [[MECommentBodyTextParser attributedStringFromString:[aCommentDict objectForKey:@"body"]] retain];
        mPubDate   = [[NSDate dateFromISO8601:[aCommentDict objectForKey:@"pubDate"]] retain];
        mAuthor    = [[MEUser userWithUserID:[[aCommentDict objectForKey:@"author"] objectForKey:@"id"]] retain];

        if (!mAuthor)
        {
            mAuthor = [[MEUser alloc] initWithDictionary:[aCommentDict objectForKey:@"author"]];
        }
    }

    return self;
}


- (void)dealloc
{
    [mCommentID release];
    [mBody release];
    [mPubDate release];
    [mAuthor release];
    [mLinks release];
    [super dealloc];
}


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
