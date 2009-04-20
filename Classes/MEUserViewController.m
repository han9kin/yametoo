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


@interface MEUserTableViewCell : UITableViewCell
{
    UIColor *mTextColor;
}

@end

@implementation MEUserTableViewCell

+ (MEUserTableViewCell *)cellInTableView:(UITableView *)aTableView
{
    id sCell = [aTableView dequeueReusableCellWithIdentifier:@"User"];

    if (!sCell)
    {
        sCell = [[[self alloc] initWithFrame:CGRectZero reuseIdentifier:@"User"] autorelease];

        [sCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];

        UIButton *sButton;
        UILabel  *sLabel;

        sButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sButton setTag:1];
        [sButton setFrame:CGRectMake(10, 15, 14, 14)];
        [[sCell contentView] addSubview:sButton];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 210, 21)];
        [sLabel setTag:2];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sButton setTag:3];
        [sButton setFrame:CGRectMake(245, 14, 11, 15)];
        [[sCell contentView] addSubview:sButton];
    }

    return sCell;
}

- (void)dealloc
{
    [mTextColor release];
    [super dealloc];
}

- (UIButton *)selectedImageButton
{
    return (UIButton *)[[self contentView] viewWithTag:1];
}

- (UILabel *)nameLabel
{
    return (UILabel *)[[self contentView] viewWithTag:2];
}

- (UIButton *)lockedImageButton
{
    return (UIButton *)[[self contentView] viewWithTag:3];
}

- (void)setClient:(MEClient *)aClient
{
    [mTextColor release];

    if (aClient == [MEClientStore currentClient])
    {
        [[self selectedImageButton] setBackgroundImage:[UIImage imageNamed:@"checkmark_normal.png"] forState:UIControlStateNormal];
        [[self selectedImageButton] setBackgroundImage:[UIImage imageNamed:@"checkmark_highlighted.png"] forState:UIControlStateHighlighted];
        mTextColor = [UIColor colorWithRed:(50 / 255.0) green:(79 / 255.0) blue:(133 / 255.0) alpha:1.0];
    }
    else
    {
        [[self selectedImageButton] setBackgroundImage:nil forState:UIControlStateNormal];
        [[self selectedImageButton] setBackgroundImage:nil forState:UIControlStateHighlighted];
        mTextColor = [UIColor blackColor];
    }

    [[self nameLabel] setText:[aClient userID]];
    [[self nameLabel] setTextColor:[mTextColor retain]];

    if ([aClient passcode])
    {
        [[self lockedImageButton] setBackgroundImage:[UIImage imageNamed:@"locked_normal.png"] forState:UIControlStateNormal];
        [[self lockedImageButton] setBackgroundImage:[UIImage imageNamed:@"locked_highlighted.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [[self lockedImageButton] setBackgroundImage:nil forState:UIControlStateNormal];
        [[self lockedImageButton] setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
}

- (void)setSelected:(BOOL)aSelected animated:(BOOL)aAnimated
{
    [super setSelected:aSelected animated:aAnimated];

    [[self selectedImageButton] setHighlighted:aSelected];
    [[self lockedImageButton] setHighlighted:aSelected];
    [[self nameLabel] setTextColor:(aSelected ? [UIColor whiteColor] : mTextColor)];
}

@end


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
    NSArray *sClients = [MEClientStore clients];

    if ([aIndexPath row] < [sClients count])
    {
        MEUserTableViewCell *sCell = [MEUserTableViewCell cellInTableView:aTableView];

        [sCell setClient:[sClients objectAtIndex:[aIndexPath row]]];

        return sCell;
    }
    else
    {
        UITableViewCell *sCell = [aTableView dequeueReusableCellWithIdentifier:@"Button"];

        if (!sCell)
        {
            sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Button"] autorelease];

            [sCell setIndentationLevel:1];
            [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }

        [sCell setText:NSLocalizedString(@"Other...", @"")];

        return sCell;
    }
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)aIndexPath
{
    NSArray *sClients = [MEClientStore clients];

    if ([aIndexPath row] < [sClients count])
    {
        UIViewController *sViewController;

        sViewController = [[MEUserDetailViewController alloc] initWithUserID:[[sClients objectAtIndex:[aIndexPath row]] userID] parentViewController:nil];
        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    NSArray *sClients = [MEClientStore clients];

    if ([aIndexPath row] < [sClients count])
    {
        MEClient *sClient;

        sClient = [sClients objectAtIndex:[aIndexPath row]];
        [MEClientStore setCurrentUserID:[sClient userID]];
    }
    else
    {
        UIViewController *sViewController;

        sViewController = [[MEUserDetailViewController alloc] initWithUserID:nil parentViewController:self];
        [self presentModalViewController:sViewController animated:YES];
        [sViewController release];
    }

    [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
}


@end
