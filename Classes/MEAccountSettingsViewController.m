/*
 *  MEAccountSettingsViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 16.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEAccountSettingsViewController.h"
#import "MEAccountDetailViewController.h"
#import "MEPasscodeViewController.h"
#import "METableViewCellFactory.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MEAccountSettingsViewController

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        [self setTitle:NSLocalizedString(@"Account", @"")];

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


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


#pragma mark -
#pragma mark MEPasscodeViewControllerDelegate


- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishAuthenticateClient:(MEClient *)aClient
{
    NSIndexPath *sIndexPath = [mTableView indexPathForSelectedRow];

    if (sIndexPath)
    {
        [MEClientStore setCurrentUserID:[aClient userID]];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    else
    {
        UIViewController *sViewController;

        sViewController = [[MEAccountDetailViewController alloc] initWithClient:aClient];
        [[self navigationController] popViewControllerAnimated:NO];
        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    return NSLocalizedString(@"Choose an Account...", @"");
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

        [sCell setIndentationWidth:20];
        [sCell setIndentationLevel:1];
        [[sCell textLabel] setText:NSLocalizedString(@"Add...", @"")];

        return sCell;
    }
}


#pragma mark -
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
            sViewController = [[MEPasscodeViewController alloc] initWithClient:sClient mode:kMEPasscodeModeAuthenticate delegate:self];
            [sViewController setTitle:NSLocalizedString(@"Enter Passcode", @"")];
        }
        else
        {
            sViewController = [[MEAccountDetailViewController alloc] initWithClient:[sClients objectAtIndex:[aIndexPath row]]];
        }

        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];
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

                sViewController = [[MEPasscodeViewController alloc] initWithClient:sClient mode:kMEPasscodeModeAuthenticate delegate:self];
                [sViewController setTitle:NSLocalizedString(@"Enter Passcode", @"")];
                [[self navigationController] pushViewController:sViewController animated:YES];
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

        sViewController = [[MEAccountDetailViewController alloc] initWithClient:nil];
        [sViewController setTitle:NSLocalizedString(@"Add Account", @"")];
        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];

        [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
    }

}


#pragma mark -
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
