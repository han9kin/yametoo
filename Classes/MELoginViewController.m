/*
 *  MELoginViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 20.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MELoginViewController.h"
#import "MEPasscodeViewController.h"
#import "MEAccountDetailViewController.h"
#import "MEAboutViewController.h"
#import "METableViewCellFactory.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"


@implementation MELoginViewController


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userListDidChangeNotification:) name:MEClientStoreUserListDidChangeNotification object:nil];
    }

    return self;
}


- (id)initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBundle
{
    self = [super initWithNibName:aNibName bundle:aBundle];

    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userListDidChangeNotification:) name:MEClientStoreUserListDidChangeNotification object:nil];
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


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mTableView setBackgroundColor:[UIColor clearColor]];
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    if (aSection == 0)
    {
        return NSLocalizedString(@"Choose an Account...", @"");
    }
    else
    {
        return NSLocalizedString(@"About", @"");
    }
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    if (aSection == 0)
    {
        return [[MEClientStore clients] count] + 1;
    }
    else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell = nil;

    if ([aIndexPath section] == 0)
    {
        NSArray *sClients = [MEClientStore clients];

        if ([aIndexPath row] < [sClients count])
        {
            MEClient *sClient = [sClients objectAtIndex:[aIndexPath row]];
            MEUser   *sUser   = [MEUser userWithUserID:[sClient userID]];

            sCell = [METableViewCellFactory userCellForTableView:aTableView];

            if (sUser)
            {
                [sCell setUser:sUser];
            }
            else
            {
                [sCell setUserID:[sClient userID]];
                [sClient getPersonWithUserID:[sClient userID] delegate:self];
            }
        }
        else
        {
            sCell = [METableViewCellFactory defaultCellForTableView:aTableView];

            [sCell setIndentationLevel:1];
            [sCell setIndentationWidth:30];
            [sCell setText:NSLocalizedString(@"Other...", @"")];
        }
    }
    else
    {
        sCell = [METableViewCellFactory defaultCellForTableView:aTableView];

        [sCell setText:NSLocalizedString(@"About", @"")];
    }

    return sCell;
}


#pragma mark -
#pragma mark UITableViewDelegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    if ([aIndexPath section] == 0)
    {
        return 70;
    }
    else
    {
        return 44;
    }
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UIViewController *sViewController;

    if ([aIndexPath section] == 0)
    {
        NSArray *sClients = [MEClientStore clients];

        if ([aIndexPath row] < [sClients count])
        {
            MEClient *sClient = [sClients objectAtIndex:[aIndexPath row]];

            if ([sClient hasPasscode])
            {
                sViewController = [[MEPasscodeViewController alloc] initWithClient:sClient mode:kMEPasscodeViewModeAuthenticate delegate:self];
                [self presentModalViewController:sViewController animated:NO];
                [sViewController release];
            }
            else
            {
                [MEClientStore setCurrentUserID:[sClient userID]];
            }
        }
        else
        {
            sViewController = [[MEAccountDetailViewController alloc] initWithUserID:nil parentViewController:self];
            [sViewController setTitle:NSLocalizedString(@"Other Account", @"")];
            [self presentModalViewController:sViewController animated:YES];
            [sViewController release];
        }
    }
    else
    {
        sViewController = [[MEAboutViewController alloc] init];
        [self presentModalViewController:sViewController animated:YES];
        [sViewController release];
    }
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    if (aUser)
    {
        [mTableView reloadData];
    }
    else
    {
        NSLog(@"MELoginViewController getPerson error: %@", aError);
    }
}


#pragma mark -
#pragma mark MEPasscodeViewControllerDelegate


- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishAuthenticationClient:(MEClient *)aClient
{
    [self dismissModalViewControllerAnimated:NO];
    [MEClientStore setCurrentUserID:[aClient userID]];
}


- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didCancelAuthenticationClient:(MEClient *)aClient
{
    [self dismissModalViewControllerAnimated:NO];
}


#pragma mark -
#pragma mark Notifications


- (void)userListDidChangeNotification:(NSNotification *)aNotification
{
    [mTableView reloadData];
}


@end
