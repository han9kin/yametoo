/*
 *  MELoginViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 20.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MELoginViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEImageView.h"
#import "METableViewCellFactory.h"
#import "MEPasscodeViewController.h"
#import "MEUserDetailViewController.h"
#import "MEAboutViewController.h"
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
#pragma mark TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    NSString *sResult = nil;

    if (aSection == 0)
    {
        sResult = NSLocalizedString(@"Choose an user...", @"");
    }
    else if (aSection == 1)
    {
        sResult = NSLocalizedString(@"About", @"");
    }

    return sResult;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    NSInteger sResult;

    if (aSection == 0)
    {
        sResult = [[MEClientStore clients] count] + 1;
    }
    else
    {
        sResult = 1;
    }

    return sResult;
}


- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sResult = nil;

    if ([aIndexPath section] == 0)
    {
        NSArray *sClients = [MEClientStore clients];

        if ([aIndexPath row] < [sClients count])
        {
            MEClient *sClient = [sClients objectAtIndex:[aIndexPath row]];
            MEUser   *sUser   = [MEUser userWithUserID:[sClient userID]];

            sResult = [METableViewCellFactory userCellForTableView:aTableView];

            if (sUser)
            {
                [sResult setUser:sUser];
            }
            else
            {
                [sClient getPersonWithUserID:[sClient userID] delegate:self];
            }
        }
        else
        {
            sResult = [METableViewCellFactory defaultCellForTableView:aTableView];

            [sResult setIndentationLevel:1];
            [sResult setIndentationWidth:30];
            [sResult setText:NSLocalizedString(@"Other...", @"")];
        }
    }
    else
    {
        sResult = [METableViewCellFactory defaultCellForTableView:aTableView];

        [sResult setText:NSLocalizedString(@"About", @"")];
    }

    return sResult;
}


#pragma mark -
#pragma mark TableView Delegate


- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    CGFloat sResult = 0;

    if ([aIndexPath section] == 0)
    {
        sResult = 70;
    }
    else
    {
        sResult = 44;
    }

    return sResult;
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
            sViewController = [[MEUserDetailViewController alloc] initWithUserID:nil parentViewController:self];
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
        NSLog(@"MELoginViewController didGetPerson error: %@", aError);
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
