/*
 *  MEFetchSettingsViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 06.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIColor+MEAdditions.h"
#import "UIViewController+MEAdditions.h"
#import "MEFetchSettingsViewController.h"
#import "METableViewCellFactory.h"
#import "MESettings.h"


@implementation MEFetchSettingsViewController


- (id)init
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        [self setTitle:NSLocalizedString(@"Fetch Post Data", @"")];
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


#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    static NSString *sTitle[] = {
        @"First fetch",
        @"Fetch more",
    };

    return sTitle[aSection];
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    static NSString *sTitle[] = {
        @"10 posts",
        @"20 posts",
        @"30 posts",
        @"50 posts",
        @"100 posts",
    };
    static NSInteger sValue[] = {
        10,
        20,
        30,
        50,
        100,
    };

    UITableViewCell *sCell;
    NSInteger        sCurrentValue;

    sCell = [METableViewCellFactory defaultCellForTableView:aTableView];

    if ([aIndexPath section] == 0)
    {
        sCurrentValue = [MESettings initialFetchCount];
    }
    else if ([aIndexPath section] == 1)
    {
        sCurrentValue = [MESettings moreFetchCount];
    }

    if (sValue[[aIndexPath row]] == sCurrentValue)
    {
        [sCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [sCell setTextColor:[UIColor selectedTextColor]];
    }
    else
    {
        [sCell setAccessoryType:UITableViewCellAccessoryNone];
        [sCell setTextColor:[UIColor blackColor]];
    }

    [sCell setText:NSLocalizedString(sTitle[[aIndexPath row]], @"")];

    return sCell;
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    static NSInteger sValue[] = {
        10,
        20,
        30,
        50,
        100,
    };

    NSIndexPath *sIndexPath = nil;
    NSInteger    sNewValue;
    NSInteger    sOldValue;
    NSInteger    i;

    sNewValue = sValue[[aIndexPath row]];

    switch ([aIndexPath section])
    {
        case 0:
            sOldValue = [MESettings initialFetchCount];
            [MESettings setInitialFetchCount:sNewValue];
            break;

        case 1:
            sOldValue = [MESettings moreFetchCount];
            [MESettings setMoreFetchCount:sNewValue];
            break;
    }

    for (i = 0; i < 5; i++)
    {
        if (sValue[i] == sOldValue)
        {
            sIndexPath = [NSIndexPath indexPathForRow:i inSection:[aIndexPath section]];
            break;
        }
    }

    [[aTableView cellForRowAtIndexPath:sIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
    [[aTableView cellForRowAtIndexPath:sIndexPath] setTextColor:[UIColor blackColor]];
    [[aTableView cellForRowAtIndexPath:aIndexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    [[aTableView cellForRowAtIndexPath:aIndexPath] setTextColor:[UIColor selectedTextColor]];

    [aTableView deselectRowAtIndexPath:aIndexPath animated:YES];
}


@end
