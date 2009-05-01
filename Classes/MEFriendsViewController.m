/*
 *  MEFriendsViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 16.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIViewController+MEAdditions.h"
#import "MEFriendsViewController.h"
#import "MEReaderView.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"
#import "MEPost.h"


@implementation MEFriendsViewController


- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *sView;

    sView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
    [sView setBackgroundColor:[UIColor colorWithRed:1.0 green:0.7 blue:0.7 alpha:1.0]];
    [[self view] addSubview:sView];
    [sView release];

    mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 25)];
    [mTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mTitleLabel setTextColor:[UIColor blackColor]];
    [mTitleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [sView addSubview:mTitleLabel];
    [mTitleLabel release];

    mReaderView = [[MEReaderView alloc] initWithFrame:CGRectMake(0, 25, 320, 386)];
    [mReaderView setDelegate:self];
    [mReaderView setShowsPostAuthor:YES];
    [[self view] addSubview:mReaderView];
    [mReaderView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    mTitleLabel = nil;
    mReaderView = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    MEClient *sClient = [MEClientStore currentClient];
    NSString *sUserID = [sClient userID];

    [mTitleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%@'s friends", @""), sUserID]];
    [mReaderView removeAllPosts];

    [sClient getPostsWithUserID:sUserID
                          scope:kMEClientGetPostsScopeFriendAll
                         offset:0
                          count:30
                       delegate:self];
}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts error:(NSError *)aError
{
    [mReaderView addPosts:aPosts];
}


@end
