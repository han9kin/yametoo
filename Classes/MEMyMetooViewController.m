/*
 *  MEMyMetooViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 07.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEMyMetooViewController.h"
#import "MEClientStore.h"


@implementation MEMyMetooViewController


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChange:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];
    }

    return self;
}

- (id)initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBundle
{
    self = [super initWithNibName:aNibName bundle:aBundle];

    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChange:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];
    }

    return self;
}


- (void)configureReaderView:(MEReaderView *)aReaderView
{
    [aReaderView setShowsPostAuthor:NO];
}

- (void)fetchFromOffset:(NSInteger)aOffset count:(NSInteger)aCount
{
    MEClient *sClient = [MEClientStore currentClient];

    [sClient getPostsWithUserID:[sClient userID] scope:kMEClientGetPostsScopeAll offset:aOffset count:aCount delegate:self];
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    NSString *sUserID = [[MEClientStore currentClient] userID];

    if ([sUserID isEqualToString:[aUser userID]] && (mUser != aUser))
    {
        [mUser release];
        mUser = [aUser retain];

        [self reloadData];
    }
}


#pragma mark -
#pragma mark MEReaderViewDataSource


- (MEUser *)authorOfPostsInReaderView:(MEReaderView *)aReaderView
{
    return mUser;
}


#pragma mark -
#pragma mark MEClientStore Notifications


- (void)currentUserDidChange:(NSNotification *)aNotification
{
    MEClient *sClient = [MEClientStore currentClient];
    NSString *sUserID = [sClient userID];

    [mUser release];
    mUser = nil;

    [sClient getPersonWithUserID:sUserID delegate:self];
    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@'s me2day", @""), sUserID]];
    [self invalidateData];
}


@end
