/*
 *  MEUserDetailViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIViewController+MEAdditions.h"
#import "MEUserDetailViewController.h"
#import "MEClientStore.h"
#import "MEClient.h"


@interface UITableViewCell (ContentViewAccessing)
@end

@implementation UITableViewCell (ContentViewAccessing)

- (UILabel *)titleLabel
{
    return (UILabel *)[[self contentView] viewWithTag:1];
}

- (UITextField *)textField
{
    return (UITextField *)[[self contentView] viewWithTag:2];
}

- (UISwitch *)switch
{
    return (UISwitch *)[self accessoryView];
}

@end


@interface MEUserDetailViewController (Private)
@end

@implementation MEUserDetailViewController (Private)

- (UITableViewCell *)textFieldCellForTableView:(UITableView *)aTableView
{
    UILabel         *sLabel;
    UITextField     *sTextField;
    UITableViewCell *sCell = [aTableView dequeueReusableCellWithIdentifier:@"InputField"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"InputField"] autorelease];

        [sCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 100, 21)];
        [sLabel setTag:1];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 6, 180, 31)];
        [sTextField setTag:2];
        [sTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [sTextField setBorderStyle:UITextBorderStyleNone];
        [sTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [sTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [sTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [sTextField setEnablesReturnKeyAutomatically:YES];
        [sTextField setDelegate:self];
        [[sCell contentView] addSubview:sTextField];
        [sTextField release];
    }

    return sCell;
}

- (UITableViewCell *)switchCellForTableView:(UITableView *)aTableView
{
    UISwitch        *sSwitch;
    UITableViewCell *sCell = [aTableView dequeueReusableCellWithIdentifier:@"Switch"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Switch"] autorelease];

        [sCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        sSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sCell setAccessoryView:sSwitch];
        [sSwitch release];
    }

    return sCell;
}

- (UITableViewCell *)buttonCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell = [aTableView dequeueReusableCellWithIdentifier:@"Button"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Button"] autorelease];

        [sCell setTextAlignment:UITextAlignmentCenter];
    }

    return sCell;
}

@end


@implementation MEUserDetailViewController

- (id)initWithUserID:(NSString *)aUserID parentViewController:(UIViewController *)aParentViewController
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mUserID               = [aUserID copy];
        mParentViewController = aParentViewController;

        [self setTitle:mUserID];
    }

    return self;
}

- (void)dealloc
{
    [mUserID release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect sTableFrame;

    if (mUserID)
    {
        UIBarButtonItem *sBarButtonItem;

        sBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Modify", @"") style:UIBarButtonItemStylePlain target:self action:@selector(modifyButtonTapped)];
        [[self navigationItem] setRightBarButtonItem:sBarButtonItem];
        [sBarButtonItem release];

        sTableFrame = CGRectMake(0, 0, 320, 416);
    }
    else
    {
        UINavigationBar  *sParentNavigationBar;
        UINavigationBar  *sNavigationBar;
        UINavigationItem *sNavigationItem;
        UIBarButtonItem  *sBarButtonItem;

        sParentNavigationBar = [[mParentViewController navigationController] navigationBar];

        sNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 74)];
        [sNavigationBar setBarStyle:[sParentNavigationBar barStyle]];
        [sNavigationBar setTintColor:[sParentNavigationBar tintColor]];
        [[self view] addSubview:sNavigationBar];
        [sNavigationBar release];

        sNavigationItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"Other User", @"")];
        [sNavigationItem setPrompt:NSLocalizedString(@"Enter user information", @"")];
        [sNavigationBar pushNavigationItem:sNavigationItem animated:NO];
        [sNavigationItem release];

        sBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTapped)];
        [sNavigationItem setLeftBarButtonItem:sBarButtonItem];
        [sBarButtonItem release];

        sBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Add", @"") style:UIBarButtonItemStylePlain target:self action:@selector(addButtonTapped)];
        [sNavigationItem setRightBarButtonItem:sBarButtonItem];
        [sBarButtonItem release];

        sTableFrame = CGRectMake(0, 74, 320, 386);
    }

    mTableView = [[UITableView alloc] initWithFrame:sTableFrame style:UITableViewStyleGrouped];
    [mTableView setScrollEnabled:NO];
    [mTableView setDataSource:self];
    [mTableView setDelegate:self];
    [[self view] addSubview:mTableView];
    [mTableView release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    mTableView    = nil;
    mUserIDField  = nil;
    mUserKeyField = nil;
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}


- (void)showError:(NSString *)aError
{
    UIAlertView *sAlertView;

    sAlertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(aError, @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
    [sAlertView show];
    [sAlertView release];
}


#pragma mark actions

- (void)cancelButtonTapped
{
    [mParentViewController dismissModalViewControllerAnimated:YES];
}

- (void)addButtonTapped
{
    if ([[mUserIDField text] length] && [[mUserKeyField text] length])
    {
        if ([MEClientStore clientForUserID:[mUserIDField text]])
        {
            [self showError:@"User already registered"];
        }
        else
        {
            MEClient *sClient;

            sClient = [[MEClient alloc] init];
            [sClient loginWithUserID:[mUserIDField text] userKey:[mUserKeyField text] delegate:self];
        }
    }
    else
    {
        [self showError:@"Please enter required fields"];
    }
}

- (void)modifyButtonTapped
{
    if ([[mUserKeyField text] length])
    {
        MEClient *sClient;

        sClient = [[MEClient alloc] init];
        [sClient loginWithUserID:mUserID userKey:[mUserKeyField text] delegate:self];
    }
    else
    {
        [self showError:@"Please enter required fields"];
    }
}

- (void)deleteButtonTapped
{
}


#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didLoginWithError:(NSError *)aError
{
    if (aError)
    {
        [self showError:[aError localizedDescription]];
    }
    else
    {
        [MEClientStore addClient:aClient];

        if (!mUserID)
        {
            [MEClientStore setCurrentUserID:[aClient userID]];
        }

        [mParentViewController dismissModalViewControllerAnimated:YES];
    }

    [aClient release];
}


#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    if (mUserID)
    {
        return 3;
    }
    else
    {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    static NSInteger sRowsForAddUser[]    = { 2, 1 };
    static NSInteger sRowsForModifyUser[] = { 1, 1, 1 };

    if (mUserID)
    {
        return sRowsForModifyUser[aSection];
    }
    else
    {
        return sRowsForAddUser[aSection];
    }
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UITableViewCell *sCell;

    switch ([aIndexPath section])
    {
        case 0:
            sCell = [self textFieldCellForTableView:aTableView];

            if (mUserID || [aIndexPath row])
            {
                mUserKeyField = [sCell textField];
                [mUserKeyField setKeyboardType:UIKeyboardTypeNumberPad];
                [mUserKeyField setReturnKeyType:UIReturnKeyJoin];
                [mUserKeyField setText:(mUserID ? @"********" : nil)];
                [[sCell titleLabel] setText:NSLocalizedString(@"User Key", @"")];
            }
            else
            {
                mUserIDField = [sCell textField];
                [mUserIDField setKeyboardType:UIKeyboardTypeASCIICapable];
                [mUserIDField setReturnKeyType:UIReturnKeyNext];
                [mUserIDField becomeFirstResponder];
                [[sCell titleLabel] setText:NSLocalizedString(@"User ID", @"")];
            }
            break;

        case 1:
            sCell = [self switchCellForTableView:aTableView];
            [sCell setText:NSLocalizedString(@"Passcode Lock", @"")];
            break;

        case 2:
            sCell = [self buttonCellForTableView:aTableView];
            [sCell setText:NSLocalizedString(@"Delete This User", @"")];
            break;
    }

    return sCell;
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    if ([aIndexPath section] == 2)
    {
        [self deleteButtonTapped];
    }

    [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    if (aTextField == mUserIDField)
    {
        [mUserKeyField becomeFirstResponder];
    }

    return YES;
}


@end