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
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MEUserViewController

- (id)initWithNibName:(NSString *)aNibName bundle:(NSBundle *)aBundle
{
    self = [super initWithNibName:aNibName bundle:aBundle];

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

- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:aAnimated];
}


- (void)userListDidChange:(NSNotification *)aNotification
{
    [mTableView reloadData];
}

- (void)currentUserDidChange:(NSNotification *)aNotification
{
    [mTableView reloadData];
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
    NSArray         *sClients;
    MEClient        *sClient;
    UITableViewCell *sCell;

    sClients = [MEClientStore clients];

    if ([aIndexPath row] < [sClients count])
    {
        sCell = [aTableView dequeueReusableCellWithIdentifier:@"User"];

        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"User"] autorelease];
        }

        sClient = [sClients objectAtIndex:[aIndexPath row]];

        [sCell setAccessoryType:((sClient == [MEClientStore client]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone)];
        [sCell setText:[sClient userID]];
    }
    else
    {
        sCell = [aTableView dequeueReusableCellWithIdentifier:@"Button"];

        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Button"] autorelease];

            [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }

        [sCell setText:NSLocalizedString(@"Other...", @"")];
    }

    return sCell;
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    if ([aIndexPath row] < [[MEClientStore clients] count])
    {
        MEClient *sClient;

        sClient = [[MEClientStore clients] objectAtIndex:[aIndexPath row]];
        [MEClientStore setCurrentUserID:[sClient userID]];

        [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
    }
    else
    {
        UIViewController *sViewController;

        sViewController = [[MEUserDetailViewController alloc] initWithUserID:nil parentViewController:self];
        [self presentModalViewController:sViewController animated:YES];
        [sViewController release];
    }
}


@end
