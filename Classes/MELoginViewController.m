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
        mFaceImageViews = [[NSMutableDictionary alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userListDidChangeNotification:) name:MEClientStoreUserListDidChangeNotification object:nil];
    }

    return self;
}


- (id)initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBundle
{
    self = [super initWithNibName:aNibName bundle:aBundle];

    if (self)
    {
        mFaceImageViews = [[NSMutableDictionary alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userListDidChangeNotification:) name:MEClientStoreUserListDidChangeNotification object:nil];
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [mTableView setBackgroundColor:[UIColor clearColor]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mFaceImageViews release];

    [super dealloc];
}


#pragma mark -
#pragma mark TableView DataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 3;
}


- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    NSString *sResult = nil;

    if (aSection == 0)
    {
        sResult = NSLocalizedString(@"Select the user to login", @"");
    }
    else if (aSection == 1)
    {
        sResult = NSLocalizedString(@"Add new user", @"");
    }
    else if (aSection == 2)
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
        sResult = [[MEClientStore clients] count];
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
        MEImageView *sFaceImageView;
        UILabel     *sUserIDLabel;
        MEClient    *sClient;
        MEUser      *sUser;

        sResult        = [METableViewCellFactory loginUserCellForTableView:aTableView];
        sFaceImageView = (MEImageView *)[[sResult contentView] viewWithTag:kLoginUserCellFaceImageViewTag];
        sUserIDLabel   = (UILabel *)[[sResult contentView] viewWithTag:kLoginUserCellUserIDLabelTag];

        sClient = [[MEClientStore clients] objectAtIndex:[aIndexPath row]];
        sUser   = [MEUser userWithUserID:[sClient userID]];

        [sUserIDLabel setText:[sClient userID]];

        if (sUser)
        {
            [sFaceImageView setImageWithURL:[sUser faceImageURL]];
        }
        else
        {
            [mFaceImageViews setObject:sFaceImageView forKey:[sClient userID]];
            [sClient getPersonWithUserID:[sClient userID] delegate:self];
        }
    }
    else if ([aIndexPath section] == 1)
    {
        sResult = [METableViewCellFactory addNewUserCellForTableView:aTableView];

        [sResult setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sResult setText:NSLocalizedString(@"Other...", @"")];
    }
    else
    {
        sResult = [METableViewCellFactory addNewUserCellForTableView:aTableView];

        [sResult setFont:[UIFont boldSystemFontOfSize:17.0]];
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
    NSArray          *sClients;
    MEClient         *sClient;

    sClients = [MEClientStore clients];

    if ([aIndexPath section] == 0)
    {
        if ([aIndexPath row] < [sClients count])
        {
            sClient = [sClients objectAtIndex:[aIndexPath row]];

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
    }
    else if ([aIndexPath section] == 1)
    {
        sViewController = [[MEUserDetailViewController alloc] initWithUserID:nil parentViewController:self];
        [self presentModalViewController:sViewController animated:YES];
        [sViewController release];
    }
    else
    {
        sViewController = [[MEAboutViewController alloc] init];
        [self presentModalViewController:sViewController animated:YES];
        [sViewController release];
    }

    [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError
{
    if (aUser)
    {
        MEImageView *sFaceImageView;

        sFaceImageView = [mFaceImageViews objectForKey:[aUser userID]];
        [sFaceImageView setImageWithURL:[aUser faceImageURL]];
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
