/*
 *  MEMymetooViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 16.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEMyMetooViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEPost.h"
#import "MEPostViewController.h"
#import "MEUser.h"


@implementation MEMyMetooViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    MEClient *sClient = [MEClientStore currentClient];
    NSString *sUserID = [sClient userID];

    [mTopBarLabel setText:[NSString stringWithFormat:@"%@'s me2day", sUserID]];

    [mReaderView setDelegate:self];
    [mReaderView setHiddenPostButton:NO];
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
