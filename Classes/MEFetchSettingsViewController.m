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


static NSInteger kValue[2][6] = {
    {  1,  5, 10, 30,  60, 0 },
    { 10, 20, 30, 50, 100, 0 }
};


@implementation MEFetchSettingsViewController


- (id)initWithType:(NSInteger)aType
{
    static NSString *sTitle[] = {
        @"Fetch New Posts",
        @"Number of Posts to Fetch",
    };

    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mType = aType;

        [self setTitle:NSLocalizedString(sTitle[mType], @"")];
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
    static NSInteger sSections[2] = { 1, 2 };

    return sSections[mType];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection
{
    static NSString *sTitle[2][2] = {
        {
            nil,
            nil,
        },
        {
            @"First fetch",
            @"Fetch more",
        }
    };

    return sTitle[mType][aSection];
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    static NSInteger sRows[2] = { 6, 5 };
    return sRows[mType];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell;
    NSString        *sText;
    NSInteger        sCurrentValue;
    NSInteger        sRowValue;

    sRowValue = kValue[mType][[aIndexPath row]];

    if (mType == 0)
    {
        sText         = [MESettings longDescriptionForFetchInterval:sRowValue];
        sCurrentValue = [MESettings fetchInterval];
    }
    else
    {
        sText = [MESettings descriptionForFetchCount:sRowValue];

        if ([aIndexPath section] == 0)
        {
            sCurrentValue = [MESettings initialFetchCount];
        }
        else
        {
            sCurrentValue = [MESettings moreFetchCount];
        }
    }

    sCell = [METableViewCellFactory defaultCellForTableView:aTableView];
    [sCell setText:sText];

    if (sRowValue == sCurrentValue)
    {
        [sCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        [sCell setTextColor:[UIColor selectedTextColor]];
    }
    else
    {
        [sCell setAccessoryType:UITableViewCellAccessoryNone];
        [sCell setTextColor:[UIColor blackColor]];
    }

    return sCell;
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{

    NSIndexPath *sIndexPath = nil;
    NSInteger    sNewValue;
    NSInteger    sOldValue;
    NSInteger    i;

    sNewValue = kValue[mType][[aIndexPath row]];

    if (mType == 0)
    {
        sOldValue = [MESettings fetchInterval];
        [MESettings setFetchInterval:sNewValue];
    }
    else
    {
        if ([aIndexPath section] == 0)
        {
            sOldValue = [MESettings initialFetchCount];
            [MESettings setInitialFetchCount:sNewValue];
        }
        else
        {
            sOldValue = [MESettings moreFetchCount];
            [MESettings setMoreFetchCount:sNewValue];
        }
    }

    for (i = 0; i < 6; i++)
    {
        if (kValue[mType][i] == sOldValue)
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
