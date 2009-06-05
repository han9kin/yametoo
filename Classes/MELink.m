/*
 *  MELink.m
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 04.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MELink.h"
#import "MEUser.h"
#import "MEClientStore.h"
#import "MEClient.h"


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

        mTitle = [aTitle copy];
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


- (void)appendTitle:(NSString *)aTitle
{
    [mTitle autorelease];
    mTitle = [[mTitle stringByAppendingString:aTitle] retain];
}


- (NSString *)urlDescription
{
    if (!mDescription)
    {
        mDescription = [[mURL absoluteString] retain];

        if ([[mURL host] isEqualToString:@"me2day.net"])
        {
            NSArray *pathComps = [[[mURL path] stringByAppendingString:@"/"] pathComponents];

            if ([pathComps count] > 1)
            {
                [[MEClientStore currentClient] getPersonWithUserID:[pathComps objectAtIndex:1] delegate:self];
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

    return mDescription;
}


#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    [self willChangeValueForKey:@"type"];

    if (aUser)
    {
        [self willChangeValueForKey:@"urlDescription"];

        [mDescription release];

        if ([mURL fragment])
        {
            mDescription = [[NSString alloc] initWithFormat:NSLocalizedString(@"%@'s Post", @""), [aUser nickname]];
            mType        = kMELinkTypePost;
        }
        else
        {
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

    NSLog(@"%@", mDescription);
}


@end
