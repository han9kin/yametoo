/*
 *  MELink.m
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 04.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MEClientStore.h"
#import "MEClient.h"
#import "MELink.h"
#import "MEUser.h"


@implementation MELink

@synthesize url   = mURL;
@synthesize title = mTitle;
@synthesize type  = mType;


- (id)initWithURL:(id)aURL title:(NSString *)aTitle
{
    self = [super init];

    if (self)
    {
        if ([aURL isKindOfClass:[NSString class]])
        {
            mURL = [[NSURL alloc] initWithString:aURL];
        }
        else
        {
            mURL = [aURL retain];
        }

        if (!mURL)
        {
            mURL         = (NSURL *)CFURLCreateWithBytes(NULL, (UInt8 *)[aURL UTF8String], [aURL lengthOfBytesUsingEncoding:NSUTF8StringEncoding], kCFStringEncodingUTF8, NULL);
            mDescription = [aURL copy];
            mType        = kMELinkTypeOther;
        }

        mTitle = [aTitle copy];
    }

    return self;
}

- (id)initWithUser:(MEUser *)aUser
{
    self = [super init];

    if (self)
    {
        mURL         = [[aUser userID] copy];
        mDescription = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@'s me2DAY", @""), [aUser nickname]];
        mType        = kMELinkTypeMe2DAY;
    }

    return self;
}

- (void)dealloc
{
    [mURL release];
    [mTitle release];
    [mDescription release];
    [super dealloc];
}


#pragma mark -
#pragma mark NSCoding


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];

    if (self)
    {
        mURL  = [[aCoder decodeObjectForKey:@"url"] retain];
        mType = [aCoder decodeIntegerForKey:@"type"];
    }

    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:mURL forKey:@"url"];
    [aCoder encodeInteger:mType forKey:@"type"];
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
        return [mURL isEqual:[aObject url]];
    }
    else
    {
        return NO;
    }
}

- (NSUInteger)hash
{
    return [mURL hash];
}


#pragma mark -


- (void)appendTitle:(NSString *)aTitle
{
    [mTitle autorelease];
    mTitle = [[mTitle stringByAppendingString:aTitle] retain];
}


- (NSString *)urlDescription
{
    NSURL    *sURL;
    NSArray  *sPathComps;
    NSString *sUserID;
    MEUser   *sUser;
    NSString *sTitle;
    NSString *sDate;
    NSString *sTime;

    if (!mDescription)
    {
        switch (mType)
        {
            case kMELinkTypeMe2DAY:
                sUser = [MEUser userWithUserID:mURL];

                if (sUser)
                {
                    mDescription = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@'s me2DAY", @""), [sUser nickname]];
                }
                else
                {
                    mDescription = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@'s me2DAY", @""), mURL];

                    [[MEClientStore currentClient] getPersonWithUserID:mURL delegate:self];
                }

                break;

            case kMELinkTypePost:
                sURL       = [NSURL URLWithString:mURL];
                sPathComps = [[[sURL path] stringByAppendingString:@"/"] pathComponents];
                sUserID    = [sPathComps objectAtIndex:1];
                sUser      = [MEUser userWithUserID:sUserID];

                if (sUser)
                {
                    sTitle = [NSString stringWithFormat:NSLocalizedString(@"%@'s Post", @""), [sUser nickname]];
                    sDate  = [[sURL path] substringFromIndex:[[sUser userID] length] + 2];
                    sTime  = [sURL fragment];

                    mDescription = [[NSString alloc] initWithFormat:@"%@ (%@ %@)", sTitle, sDate, sTime];
                }
                else
                {
                    sTitle = [NSString stringWithFormat:NSLocalizedString(@"%@'s Post", @""), sUserID];
                    sDate  = [[sURL path] substringFromIndex:[sUserID length] + 2];
                    sTime  = [sURL fragment];

                    mDescription = [[NSString alloc] initWithFormat:@"%@ (%@ %@)", sTitle, sDate, sTime];

                    [[MEClientStore currentClient] getPersonWithUserID:sUserID delegate:self];
                }

                break;

            case kMELinkTypeOther:
                mDescription = [mURL copy];
                break;

            default:
                if (mURL)
                {
                    mDescription = [[mURL absoluteString] retain];

                    if ([[mURL host] isEqualToString:@"me2day.net"])
                    {
                        sPathComps = [[[mURL path] stringByAppendingString:@"/"] pathComponents];

                        if ([sPathComps count] > 1)
                        {
                            sUserID = [sPathComps objectAtIndex:1];
                            sUser   = [MEUser userWithUserID:sUserID];

                            if (sUser)
                            {
                                [self client:nil didGetPerson:sUser error:nil];
                            }
                            else
                            {
                                [[MEClientStore currentClient] getPersonWithUserID:sUserID delegate:self];
                            }
                        }
                        else
                        {
                            [self willChangeValueForKey:@"type"];
                            mType = kMELinkTypeOther;
                            [self didChangeValueForKey:@"type"];
                        }
                    }
                    else
                    {
                        [self willChangeValueForKey:@"type"];
                        mType = kMELinkTypeOther;
                        [self didChangeValueForKey:@"type"];
                    }
                }
                else
                {
                    mDescription = @"<Invalid URL>";

                    [self willChangeValueForKey:@"type"];
                    mType = kMELinkTypeOther;
                    [self didChangeValueForKey:@"type"];
                }

                break;
        }
    }

    return mDescription;
}


#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    NSURL    *sURL;
    NSString *sTitle;
    NSString *sDate;
    NSString *sTime;

    [self willChangeValueForKey:@"type"];

    if (aUser)
    {
        [self willChangeValueForKey:@"urlDescription"];

        switch (mType)
        {
            case kMELinkTypeMe2DAY:
                [mDescription release];
                mDescription = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@'s me2DAY", @""), [aUser nickname]];
                break;

            case kMELinkTypePost:
                sURL   = [NSURL URLWithString:mURL];
                sTitle = [NSString stringWithFormat:NSLocalizedString(@"%@'s Post", @""), [aUser nickname]];
                sDate  = [[sURL path] substringFromIndex:[[aUser userID] length] + 2];
                sTime  = [sURL fragment];

                [mDescription release];
                mDescription = [[NSString alloc] initWithFormat:@"%@ (%@ %@)", sTitle, sDate, sTime];

                break;

            default:
                [mURL autorelease];
                [mDescription release];

                if ([mURL fragment] && ([[mURL path] length] > ([[aUser userID] length] + 2)))
                {
                    sTitle = [NSString stringWithFormat:NSLocalizedString(@"%@'s Post", @""), [aUser nickname]];
                    sDate  = [[mURL path] substringFromIndex:[[aUser userID] length] + 2];
                    sTime  = [mURL fragment];

                    mURL         = [[mURL absoluteString] copy];
                    mDescription = [[NSString alloc] initWithFormat:@"%@ (%@ %@)", sTitle, sDate, sTime];
                    mType        = kMELinkTypePost;
                }
                else
                {
                    mURL         = [[aUser userID] copy];
                    mDescription = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@'s me2DAY", @""), [aUser nickname]];
                    mType        = kMELinkTypeMe2DAY;
                }

                break;
        }

        [self didChangeValueForKey:@"urlDescription"];
    }
    else
    {
        mType = kMELinkTypeOther;
    }

    [self didChangeValueForKey:@"type"];
}


@end
