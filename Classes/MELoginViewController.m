/*
 *  MELoginViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 20.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "MELoginViewController.h"
#import "MEPasscodeViewController.h"
#import "MEAccountDetailViewController.h"
#import "MEAboutViewController.h"
#import "METableViewCellFactory.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"


@implementation MELoginViewController

@synthesize tableView = mTableView;


- (id)init
{
    self = [super initWithNibName:@"LoginView" bundle:nil];

    if (self)
    {
        [self setTitle:NSLocalizedString(@"Login", @"")];
    }

    return self;
}


- (void)dealloc
{
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mTableView setBackgroundColor:[UIColor colorWithWhite:0.85 alpha:1.0]];
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

    if ([MEClientStore currentClient])
    {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


- (void)dismiss
{
    [self dismissModalViewControllerAnimated:YES];
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

            [sCell setIndentationWidth:70];
            [sCell setIndentationLevel:1];
            [[sCell textLabel] setText:NSLocalizedString(@"Other...", @"")];
        }
    }
    else
    {
        sCell = [METableViewCellFactory defaultCellForTableView:aTableView];

        [[sCell textLabel] setText:NSLocalizedString(@"About", @"")];
    }

    return sCell;
}


#pragma mark -
#pragma mark UITableViewDelegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    if ([aIndexPath section] == 0)
    {
        return 60;
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
                sViewController = [[MEPasscodeViewController alloc] initWithClient:sClient mode:kMEPasscodeModeAuthenticate delegate:self];
                [sViewController setTitle:NSLocalizedString(@"Enter Passcode", @"")];
                [[self navigationController] pushViewController:sViewController animated:YES];
                [sViewController release];
            }
            else
            {
                mDismissAfterLogin = YES;
                [sClient loginWithUserID:nil userKey:nil delegate:self];
            }
        }
        else
        {
            sViewController = [[MEAccountDetailViewController alloc] initWithClient:nil];
            [sViewController setTitle:NSLocalizedString(@"Other Account", @"")];
            [[self navigationController] pushViewController:sViewController animated:YES];
            [sViewController release];
        }
    }
    else
    {
        sViewController = [[MEAboutViewController alloc] init];
        [[self navigationController] pushViewController:sViewController animated:YES];
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


- (void)client:(MEClient *)aClient didLoginWithError:(NSError *)aError
{
    if (aError)
    {
        [[self navigationController] popViewControllerAnimated:YES];

        [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:YES];

        [UIAlertView showError:aError];
    }
    else
    {
        [MEClientStore setCurrentUserID:[aClient userID]];

        if (mDismissAfterLogin)
        {
            [self dismiss];
        }
    }

    mDismissAfterLogin = NO;
}


#pragma mark -
#pragma mark MEPasscodeViewControllerDelegate


- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishAuthenticateClient:(MEClient *)aClient
{
    [aClient loginWithUserID:nil userKey:nil delegate:self];

    [[self navigationController] popViewControllerAnimated:YES];
}


@end
