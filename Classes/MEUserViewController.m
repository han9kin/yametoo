/*
 *  MEUserViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 16.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIViewController+MEAdditions.h"
#import "MEUserViewController.h"
#import "MEUserDetailViewController.h"
#import "MEPasscodeViewController.h"
#import "METableViewCellFactory.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MEUserViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        [self setTitle:NSLocalizedString(@"User", @"")];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userListDidChange:) name:MEClientStoreUserListDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChange:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    mTableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStyleGrouped];
    [mTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [mTableView setDataSource:self];
    [mTableView setDelegate:self];
    [[self view] addSubview:mTableView];
    [mTableView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    mTableView = nil;
}


#pragma mark MEPasscodeViewControllerDelegate


- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishAuthenticationClient:(MEClient *)aClient
{
    NSIndexPath *sIndexPath;

    [self dismissModalViewControllerAnimated:NO];

    sIndexPath = [mTableView indexPathForSelectedRow];

    if (sIndexPath)
    {
        [MEClientStore setCurrentUserID:[[[MEClientStore clients] objectAtIndex:[sIndexPath row]] userID]];
        [mTableView deselectRowAtIndexPath:sIndexPath animated:YES];
    }
    else
    {
        UIViewController *sViewController;

        sViewController = [[MEUserDetailViewController alloc] initWithUserID:[aClient userID] parentViewController:nil];
        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];
    }
}

- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didCancelAuthenticationClient:(MEClient *)aClient
{
    [self dismissModalViewControllerAnimated:NO];
    [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:YES];
}


#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    return NSLocalizedString(@"Choose an User...", @"");
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return [[MEClientStore userIDs] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell;
    NSArray         *sClients;

    sClients = [MEClientStore clients];

    if ([aIndexPath row] < [sClients count])
    {
        sCell = [METableViewCellFactory clientCellForTableView:aTableView];

        [sCell setClient:[sClients objectAtIndex:[aIndexPath row]]];

        return sCell;
    }
    else
    {
        sCell = [METableViewCellFactory defaultCellForTableView:aTableView];

        [sCell setIndentationLevel:1];
        [sCell setText:NSLocalizedString(@"Other...", @"")];

        return sCell;
    }
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)aIndexPath
{
    NSArray *sClients = [MEClientStore clients];

    if ([aIndexPath row] < [sClients count])
    {
        MEClient         *sClient = [sClients objectAtIndex:[aIndexPath row]];
        UIViewController *sViewController;

        if ([sClient hasPasscode])
        {
            sViewController = [[MEPasscodeViewController alloc] initWithClient:sClient mode:kMEPasscodeViewModeAuthenticate delegate:self];
            [self presentModalViewController:sViewController animated:NO];
            [sViewController release];
        }
        else
        {
            sViewController = [[MEUserDetailViewController alloc] initWithUserID:[[sClients objectAtIndex:[aIndexPath row]] userID] parentViewController:nil];
            [[self navigationController] pushViewController:sViewController animated:YES];
            [sViewController release];
        }
    }
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    NSArray *sClients = [MEClientStore clients];

    if ([aIndexPath row] < [sClients count])
    {
        MEClient *sClient = [sClients objectAtIndex:[aIndexPath row]];

        if (sClient == [MEClientStore currentClient])
        {
            [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
        }
        else
        {
            if ([sClient hasPasscode])
            {
                UIViewController *sViewController;

                sViewController = [[MEPasscodeViewController alloc] initWithClient:sClient mode:kMEPasscodeViewModeAuthenticate delegate:self];
                [self presentModalViewController:sViewController animated:NO];
                [sViewController release];
            }
            else
            {
                [MEClientStore setCurrentUserID:[sClient userID]];
                [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
            }
        }
    }
    else
    {
        UIViewController *sViewController;

        sViewController = [[MEUserDetailViewController alloc] initWithUserID:nil parentViewController:self];
        [self presentModalViewController:sViewController animated:YES];
        [sViewController release];

        [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
    }

}


#pragma mark MEClientStoreNotifications


- (void)userListDidChange:(NSNotification *)aNotification
{
    [mTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
}

- (void)currentUserDidChange:(NSNotification *)aNotification
{
    [mTableView performSelector:@selector(reloadData) withObject:nil afterDelay:0];
}


@end
