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
#import "MEUserViewController.h"
#import "MEAboutViewController.h"


@implementation MESettingsViewController

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

- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:aAnimated];
}


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
    UITableViewCell *sCell;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Default"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Default"] autorelease];
    }

    switch ([aIndexPath section])
    {
        case 0:
            [sCell setText:NSLocalizedString(@"User", @"")];
            break;

        case 1:
            [sCell setText:NSLocalizedString(@"About", @"")];
            break;
    }

    [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    return sCell;
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UIViewController *sViewController;

    switch ([aIndexPath section])
    {
        case 0:
            sViewController = [[MEUserViewController alloc] init];
            break;

        case 1:
            sViewController = [[MEAboutViewController alloc] init];
            break;
    }

    [[self navigationController] pushViewController:sViewController animated:YES];
    [sViewController release];
}


@end
