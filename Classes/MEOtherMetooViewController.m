/*
 *  MEOtherMetooViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 11.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MEReaderView.h"
#import "MEOtherMetooViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"


@implementation MEOtherMetooViewController


- (id)initWithUserID:(NSString *)aUserID
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mUserID = [aUserID copy];
    }

    return self;
}

- (void)dealloc
{
    [mUserID release];
    [super dealloc];
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@'s me2DAY", @""), mUserID]];
    [[MEClientStore currentClient] getPersonWithUserID:mUserID delegate:self];

    [self setTitleUserID:mUserID];
}


- (void)configureReaderView:(MEReaderView *)aReaderView
{
    [aReaderView setShowsPostAuthor:NO];
}

- (void)fetchFromOffset:(NSInteger)aOffset count:(NSInteger)aCount
{
    [[MEClientStore currentClient] getPostsWithUserID:mUserID scope:kMEClientGetPostsScopeAll offset:aOffset count:aCount delegate:self];
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    NSString *sName;

    if (aUser)
    {
        sName = [aUser nickname];
    }
    else
    {
        sName = [[MEClientStore currentClient] userID];
    }

    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@'s me2DAY", @""), sName]];
}


@end
