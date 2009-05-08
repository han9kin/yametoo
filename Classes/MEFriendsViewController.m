/*
 *  MEFriendsViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 07.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEFriendsViewController.h"
#import "MEClientStore.h"


@implementation MEFriendsViewController


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
    [aReaderView setShowsPostAuthor:YES];
}

- (void)fetchFromOffset:(NSInteger)aOffset count:(NSInteger)aCount
{
    MEClient *sClient = [MEClientStore currentClient];

    [sClient getPostsWithUserID:[sClient userID] scope:kMEClientGetPostsScopeFriendAll offset:aOffset count:aCount delegate:self];
}


#pragma mark -
#pragma mark MEClientStore Notifications


- (void)currentUserDidChange:(NSNotification *)aNotification
{
    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@'s friends", @""), [[MEClientStore currentClient] userID]]];
    [self refreshData];
}


@end
