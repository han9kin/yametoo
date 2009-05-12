/*
 *  MEComment.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSDate+MEAdditions.h"
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
    [super dealloc];
}


@end
