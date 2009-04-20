/*
 *  MEPost.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEPost.h"


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
@synthesize tags          = mTagArray;
@synthesize me2PhotoImage = mMe2PhotoImage;
@synthesize kindIconImage = mKindIconImage;


#pragma mark -
#pragma mark init/dealloc


- (id)initWithDictionary:(NSDictionary *)aPostDict
{
    self = [super init];

    if (self)
    {
        mPostID              = [[aPostDict objectForKey:@"post_id"] retain];
        mBody                = [[aPostDict objectForKey:@"body"] retain];
        mKind                = [[aPostDict objectForKey:@"kind"] retain];
        mPubDate             = [[self dateFromString:[aPostDict objectForKey:@"pubDate"]] retain];
        mCommentsCount       = [[aPostDict objectForKey:@"commentsCount"] integerValue];
        mMetooCount          = [[aPostDict objectForKey:@"metooCount"] integerValue];
        mUser;
        mTagArray            = [[[aPostDict objectForKey:@"tags"] valueForKey:@"name"] retain];
        mMe2PhotoImageURLStr = [[[aPostDict objectForKey:@"media"] objectForKey:@"photoUrl"] retain];
        mKindIconImageURLStr = [[aPostDict objectForKey:@"icon"] retain];
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
    [mTagArray release];

    [mMe2PhotoImageURLStr release];
    [mKindIconImageURLStr release];

    [mMe2PhotoImage release];
    [mKindIconImage release];

    [super dealloc];
}


#pragma mark -
#pragma mark Instance Methods


@end
