/*
 *  MEPasscodeSettingsViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 15.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MEPasscodeSettingsViewController.h"
#import "MEPasscodeViewController.h"
#import "METableViewCellFactory.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MEPasscodeSettingsViewController


- (id)initWithClient:(MEClient *)aClient
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mClient = aClient;

        [self setTitle:NSLocalizedString(@"Passcode Lock", @"")];
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


#pragma mark -
#pragma mark MEPasscodeViewControllerDelegate


- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishAuthenticateClient:(MEClient *)aClient
{
    [aClient setPasscode:nil];
    [MEClientStore addClient:aClient];

    [[self navigationController] popViewControllerAnimated:NO];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishChangeClient:(MEClient *)aClient
{
    [MEClientStore addClient:aClient];

    [[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell = nil;

    switch ([aIndexPath section])
    {
        case 0:
            sCell = [METableViewCellFactory buttonCellForTableView:aTableView];
            [[sCell textLabel] setText:NSLocalizedString(@"Delete Passcode", @"")];
            break;

        case 1:
            sCell = [METableViewCellFactory buttonCellForTableView:aTableView];
            [[sCell textLabel] setText:NSLocalizedString(@"Change Passcode", @"")];
            break;
    }

    return sCell;
}


#pragma mark -
#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UIViewController *sViewController = nil;

    switch ([aIndexPath section])
    {
        case 0:
            sViewController = [[MEPasscodeViewController alloc] initWithClient:mClient mode:kMEPasscodeModeAuthenticate delegate:self];
            [sViewController setTitle:NSLocalizedString(@"Delete Passcode", @"")];
            break;

        case 1:
            sViewController = [[MEPasscodeViewController alloc] initWithClient:mClient mode:kMEPasscodeModeChange delegate:self];
            [sViewController setTitle:NSLocalizedString(@"Change Passcode", @"")];
            break;
    }

    [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];

    if (sViewController)
    {
        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];
    }
}


@end
