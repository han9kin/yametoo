/*
 *  MESettingsViewController.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIViewController+MEAdditions.h"
#import "MESettingsViewController.h"
#import "MEUserSettingsViewController.h"
#import "MEFetchSettingsViewController.h"
#import "MEAboutViewController.h"
#import "METableViewCellFactory.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MESettingsViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentUserDidChange:) name:MEClientStoreCurrentUserDidChangeNotification object:nil];
    }

    return self;
}

- (id)initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBundle
{
    self = [super initWithNibName:aNibName bundle:aBundle];

    if (self)
    {
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
    [mTableView setScrollEnabled:NO];
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

    [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:aAnimated];
}


#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell;

    switch ([aIndexPath section])
    {
        case 0:
            sCell = [METableViewCellFactory detailCellForTableView:aTableView];
            [sCell setTitleText:NSLocalizedString(@"User", @"")];
            [sCell setDetailText:[[MEClientStore currentClient] userID]];
            break;

        case 1:
            sCell = [METableViewCellFactory defaultCellForTableView:aTableView];
            [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [sCell setText:NSLocalizedString(@"Fetch Post Data", @"")];
            break;

        case 2:
            sCell = [METableViewCellFactory defaultCellForTableView:aTableView];
            [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [sCell setText:NSLocalizedString(@"About", @"")];
            break;

        default:
            sCell = nil;
            break;
    }

    return sCell;
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UIViewController *sViewController;

    switch ([aIndexPath section])
    {
        case 0:
            sViewController = [[MEUserSettingsViewController alloc] init];
            break;

        case 1:
            sViewController = [[MEFetchSettingsViewController alloc] init];
            break;

        case 2:
            sViewController = [[MEAboutViewController alloc] init];
            break;
    }

    [[self navigationController] pushViewController:sViewController animated:YES];
    [sViewController release];
}


#pragma mark MEClientStore Notification


- (void)currentUserDidChange:(NSNotification *)aNotification
{
    [mTableView reloadData];
}


@end
