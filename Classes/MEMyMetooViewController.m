/*
 *  MEMymetooViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 16.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIViewController+MEAdditions.h"
#import "MEMyMetooViewController.h"
#import "MEPostViewController.h"
#import "MEReaderView.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"
#import "MEPost.h"


@implementation MEMyMetooViewController


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
    [mReaderView setHiddenPostButton:NO];
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

    [mTitleLabel setText:[NSString stringWithFormat:NSLocalizedString(@"%@'s me2day", @""), sUserID]];
    [mReaderView removeAllPosts];

    [sClient getPersonWithUserID:sUserID delegate:self];
    [sClient getPostsWithUserID:sUserID
                          scope:kMEClientGetPostsScopeAll
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


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    MEClient *sClient = [MEClientStore currentClient];
    NSString *sUserID = [sClient userID];

    if ([sUserID isEqualToString:[aUser userID]])
    {
        [mReaderView setUser:aUser];
    }
}


- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts error:(NSError *)aError
{
    [mReaderView addPosts:aPosts];
}


#pragma mark -
#pragma mark MEReaderView Delegate


- (void)newPostForReaderView:(MEReaderView *)aReaderView
{
    UIViewController *sViewController;

    sViewController = [[MEPostViewController alloc] initWithNibName:@"PostViewController" bundle:nil];
    [self presentModalViewController:sViewController animated:YES];
    [sViewController release];
}


@end
