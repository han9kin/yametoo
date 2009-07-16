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
        mURL         = [[aCoder decodeObjectForKey:@"url"] retain];
        mDescription = [[aCoder decodeObjectForKey:@"description"] retain];
        mType        = [aCoder decodeIntegerForKey:@"type"];
    }

    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:mURL forKey:@"url"];
    [aCoder encodeObject:mDescription forKey:@"description"];
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
    if (!mDescription)
    {
        if (mURL)
        {
            mDescription = [[mURL absoluteString] retain];

            if ([[mURL host] isEqualToString:@"me2day.net"])
            {
                NSArray *pathComps = [[[mURL path] stringByAppendingString:@"/"] pathComponents];

                if ([pathComps count] > 1)
                {
                    NSString *sUserID = [pathComps objectAtIndex:1];
                    MEUser   *sUser   = [MEUser userWithUserID:sUserID];

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
    }

    return mDescription;
}


#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    [self willChangeValueForKey:@"type"];

    if (aUser)
    {
        [self willChangeValueForKey:@"urlDescription"];

        [mURL autorelease];
        [mDescription release];

        if ([mURL fragment] && ([[mURL path] length] > ([[aUser userID] length] + 2)))
        {
            NSString *sTitle = [NSString stringWithFormat:NSLocalizedString(@"%@'s Post", @""), [aUser nickname]];
            NSString *sDate  = [[mURL path] substringFromIndex:[[aUser userID] length] + 2];
            NSString *sTime  = [mURL fragment];

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

        [self didChangeValueForKey:@"urlDescription"];
    }
    else
    {
        mType = kMELinkTypeOther;
    }

    [self didChangeValueForKey:@"type"];
}


@end
