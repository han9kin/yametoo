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
@synthesize tags          = mTagArray;
@dynamic    me2PhotoImage;
@dynamic    kindIconImage;


#pragma mark -
#pragma mark init/dealloc


- (id)initWithDictionary:(NSDictionary *)aPostDict
{
    self = [super init];

    if (self)
    {
        mPostID           = [[aPostDict objectForKey:@"post_id"] retain];
        mBody             = [[aPostDict objectForKey:@"body"] retain];
        mKind             = [[aPostDict objectForKey:@"kind"] retain];
        mPubDate          = [[self dateFromString:[aPostDict objectForKey:@"pubDate"]] retain];
        mCommentsCount    = [[aPostDict objectForKey:@"commentsCount"] integerValue];
        mMetooCount       = [[aPostDict objectForKey:@"metooCount"] integerValue];
        mUser             = [[MEUser alloc] initWithDictionary:[aPostDict objectForKey:@"author"]];
        mTagArray         = [[[aPostDict objectForKey:@"tags"] valueForKey:@"name"] retain];
        mMe2PhotoImageURL = [[NSURL alloc] initWithStringOrNil:[[aPostDict objectForKey:@"media"] objectForKey:@"photoUrl"]];
        mKindIconImageURL = [[NSURL alloc] initWithStringOrNil:[aPostDict objectForKey:@"icon"]];
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

    [mMe2PhotoImageURL release];
    [mKindIconImageURL release];

    [mMe2PhotoImage release];
    [mKindIconImage release];

    [super dealloc];
}


#pragma mark -


- (NSString *)tagsString
{
    NSMutableString *sResult = [NSMutableString string];
    NSString        *sTag;
    
    for (sTag in mTagArray)
    {
        [sResult appendFormat:@"%@ ", sTag];
    }
    
    return sResult;
}


#pragma mark -
#pragma mark dynamic property accessors


- (UIImage *)me2PhotoImage
{
    if (!mMe2PhotoImage)
    {
        if (mMe2PhotoImageURL)
        {
            mMe2PhotoImage = [MEFuture future];
            [[MEClientStore currentClient] loadImageWithURL:mMe2PhotoImageURL key:@"me2PhotoImage" shouldCache:NO delegate:self];
        }
    }

    return mMe2PhotoImage;
}


- (UIImage *)kindIconImage
{
    if (!mKindIconImage)
    {
        if (mKindIconImageURL)
        {
            mKindIconImage = [MEFuture future];
            [[MEClientStore currentClient] loadImageWithURL:mKindIconImageURL key:@"kindIconImage" shouldCache:YES delegate:self];
        }
    }

    return mKindIconImage;
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didLoadImage:(UIImage *)aImage key:(NSString *)aKey error:(NSError *)aError
{
    if ([aKey isEqualToString:@"me2PhotoImage"])
    {
        if (mMe2PhotoImage != aImage)
        {
            [self willChangeValueForKey:@"me2PhotoImage"];
            [mMe2PhotoImage release];
            mMe2PhotoImage = [aImage retain];
            [self didChangeValueForKey:@"me2PhotoImage"];
        }
    }
    else if ([aKey isEqualToString:@"kindIconImage"])
    {
        if (mKindIconImage != aImage)
        {
            [self willChangeValueForKey:@"kindIconImage"];
            [mKindIconImage release];
            mKindIconImage = [aImage retain];
            [self didChangeValueForKey:@"kindIconImage"];
        }
    }
}


@end
