/*
 *  MEComment.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEComment.h"
#import "MECommentBodyTextParser.h"
#import "MEUser.h"



@interface MEComment (DateFormatting)
@end

@implementation MEComment (DateFormatting)

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
        mPubDate   = [[self dateFromString:[aCommentDict objectForKey:@"pubDate"]] retain];
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
