/*
 *  MEUserListViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 11.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MEUserListViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"


@implementation MEUserListViewController


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChange:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];
    }

    return self;
}

- (id)initWithUserID:(NSString *)aUserID
{
    self = [super init];

    if (self)
    {
        mUserID = [aUserID copy];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mUserID release];
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setToolbarItems:[NSArray arrayWithObjects:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Friends", @"") style:UIBarButtonItemStyleBordered target:nil action:NULL] autorelease], nil]];
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@'s me2DAY", @""), mUserID]];
    [[MEClientStore currentClient] getPersonWithUserID:mUserID delegate:self];

    [self setTitleUserID:mUserID];
}


- (void)configureListView:(MEListView *)aListView
{
    [aListView setShowsPostAuthor:NO];
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


#pragma mark -
#pragma mark MEClientStore Notifications


- (void)currentUserDidChange:(NSNotification *)aNotification
{
    MEClient *sClient = [MEClientStore currentClient];
    NSString *sUserID = [sClient userID];

    [mUserID release];
    mUserID = [sUserID copy];

    [self setTitle:[NSString stringWithFormat:NSLocalizedString(@"%@'s me2DAY", @""), sUserID]];
    [sClient getPersonWithUserID:sUserID delegate:self];

    [self setTitleUserID:sUserID];
    [self invalidateData];
}


@end
