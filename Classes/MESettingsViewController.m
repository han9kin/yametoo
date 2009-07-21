/*
 *  MESettingsViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MESettingsViewController.h"
#import "MEAccountSettingsViewController.h"
#import "MEFetchSettingsViewController.h"
#import "MEAboutViewController.h"
#import "METableViewCellFactory.h"
#import "MESettings.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MESettingsViewController


- (id)init
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        [self setTitle:NSLocalizedString(@"Settings", @"")];

        [[self navigationItem] setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStylePlain target:[[UIApplication sharedApplication] delegate] action:@selector(hideSettings)] autorelease]];
    }

    return self;
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


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    [mTableView reloadData];
}

- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:aAnimated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    NSInteger sRows[] = { 1, 2, 1 };

    return sRows[aSection];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell;

    switch ([aIndexPath section])
    {
        case 0:
            sCell = [METableViewCellFactory detailCellForTableView:aTableView];
            [[sCell textLabel] setText:NSLocalizedString(@"Account", @"")];
            [[sCell detailTextLabel] setText:[[MEClientStore currentClient] userID]];
            [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;

        case 1:
            if ([aIndexPath row] == 0)
            {
                sCell = [METableViewCellFactory detailCellForTableView:aTableView];
                [[sCell textLabel] setText:NSLocalizedString(@"Fetch New Posts", @"")];
                [[sCell detailTextLabel] setText:[MESettings shortDescriptionForFetchInterval:[MESettings fetchInterval]]];
            }
            else
            {
                sCell = [METableViewCellFactory defaultCellForTableView:aTableView];
                [[sCell textLabel] setText:NSLocalizedString(@"Number of Posts to Fetch", @"")];
            }

            [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;

        case 2:
            sCell = [METableViewCellFactory defaultCellForTableView:aTableView];
            [[sCell textLabel] setText:NSLocalizedString(@"About", @"")];
            [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;

        default:
            sCell = nil;
            break;
    }

    return sCell;
}


#pragma mark -
#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UIViewController *sViewController;

    switch ([aIndexPath section])
    {
        case 0:
            sViewController = [[MEAccountSettingsViewController alloc] init];
            break;

        case 1:
            sViewController = [[MEFetchSettingsViewController alloc] initWithType:[aIndexPath row]];
            break;

        case 2:
            sViewController = [[MEAboutViewController alloc] init];
            break;

        default:
            sViewController = nil;
    }

    if (sViewController)
    {
        [sViewController setHidesBottomBarWhenPushed:YES];
        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];
    }
}


@end
