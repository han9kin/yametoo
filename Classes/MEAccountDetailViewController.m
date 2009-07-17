/*
 *  MEAccountDetailViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "MEAccountDetailViewController.h"
#import "MEPasscodeViewController.h"
#import "MEPasscodeSettingsViewController.h"
#import "METableViewCellFactory.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MEAccountDetailViewController

- (id)initWithClient:(MEClient *)aClient
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mClient = [aClient retain];

        if (mClient)
        {
            [self setTitle:[mClient userID]];
            [[self navigationItem] setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStyleDone target:self action:@selector(modifyAccount)] autorelease]];
        }
        else
        {
            mClient = [[MEClient alloc] init];
            [[self navigationItem] setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(([MEClientStore currentClient] ? @"Save" : @"Login"), @"") style:UIBarButtonItemStyleDone target:self action:@selector(addAccount)] autorelease]];
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userListDidChange:) name:MEClientStoreUserListDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [mClient release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

    mTableView      = nil;
    mUserIDField    = nil;
    mUserKeyField   = nil;
}


- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [mTableView deselectRowAtIndexPath:[mTableView indexPathForSelectedRow] animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


#pragma mark actions


- (void)addAccount
{
    if ([[mUserIDField text] length] && [[mUserKeyField text] length])
    {
        if ([MEClientStore clientForUserID:[mUserIDField text]])
        {
            [UIAlertView showAlert:@"Account already registered."];
        }
        else
        {
            [mClient loginWithUserID:[mUserIDField text] userKey:[mUserKeyField text] delegate:self];
        }
    }
    else
    {
        [UIAlertView showAlert:@"Please enter required fields."];
    }
}

- (void)modifyAccount
{
    if ([[mUserKeyField text] length])
    {
        [mClient loginWithUserID:[mClient userID] userKey:[mUserKeyField text] delegate:self];
    }
    else
    {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (void)deleteAccount
{
    UIActionSheet *sActionSheet;
    NSString      *sTitle;

    sTitle = [NSString stringWithFormat:NSLocalizedString(@"Delete account \"%@\".", @""), [mClient userID]];

    sActionSheet = [[UIActionSheet alloc] initWithTitle:sTitle delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete Account", @"") otherButtonTitles:nil];
    [sActionSheet showInView:[self view]];
    [sActionSheet release];
}


#pragma mark -
#pragma mark UIKeyboard Notifications


- (void)keyboardDidShow:(NSNotification *)aNotification
{
    CGRect sRect = [[self view] bounds];

    sRect.size.height -= [[[aNotification userInfo] objectForKey:UIKeyboardBoundsUserInfoKey] CGRectValue].size.height;

    [mTableView setFrame:sRect];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [mTableView setFrame:[[self view] bounds]];
}


#pragma mark -
#pragma mark MEClientStoreNotifications


- (void)userListDidChange:(NSNotification *)aNotification
{
    [mTableView reloadData];
}


#pragma mark -
#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didLoginWithError:(NSError *)aError
{
    if (aError)
    {
        [UIAlertView showError:aError];
    }
    else
    {
        [MEClientStore addClient:aClient];

        if (![MEClientStore currentClient])
        {
            [MEClientStore setCurrentUserID:[aClient userID]];
        }

        [[self navigationController] popViewControllerAnimated:YES];
    }
}


#pragma mark -
#pragma mark MEPasscodeViewControllerDelegate


- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishChangeClient:(MEClient *)aClient
{
    UIViewController *sViewController;

    sViewController = [[MEPasscodeSettingsViewController alloc] initWithClient:mClient];
    [[self navigationController] popViewControllerAnimated:NO];
    [[self navigationController] pushViewController:sViewController animated:YES];
    [sViewController release];

    [MEClientStore addClient:aClient];
}


#pragma mark -
#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    if ([mClient userID])
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

    if ([mClient userID])
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
    UITableViewCell *sCell = nil;

    if ([mClient userID])
    {
        switch ([aIndexPath section])
        {
            case 0:
                sCell = [METableViewCellFactory buttonCellForTableView:aTableView];
                [[sCell textLabel] setText:NSLocalizedString(@"Delete this Account", @"")];
                break;

            case 1:
                sCell = [METableViewCellFactory textFieldCellForTableView:aTableView];
                [sCell setTitleText:NSLocalizedString(@"User Key", @"")];

                mUserKeyField = [sCell textField];
                [mUserKeyField setKeyboardType:UIKeyboardTypeNamePhonePad];
                [mUserKeyField setReturnKeyType:UIReturnKeyDone];
                [mUserKeyField setPlaceholder:NSLocalizedString(@"me2API User Key", @"")];
                [mUserKeyField setDelegate:self];
                break;

            case 2:
                sCell = [METableViewCellFactory detailCellForTableView:aTableView];
                [[sCell textLabel] setText:NSLocalizedString(@"Passcode Lock", @"")];
                [[sCell detailTextLabel] setText:NSLocalizedString(([mClient hasPasscode] ? @"On" : @"Off"), @"")];
                [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
        }
    }
    else
    {
        switch ([aIndexPath section])
        {
            case 0:
                sCell = [METableViewCellFactory textFieldCellForTableView:aTableView];

                if ([aIndexPath row] == 0)
                {
                    [sCell setTitleText:NSLocalizedString(@"User ID", @"")];

                    mUserIDField = [sCell textField];
                    [mUserIDField setKeyboardType:UIKeyboardTypeDefault];
                    [mUserIDField setReturnKeyType:UIReturnKeyNext];
                    [mUserIDField setPlaceholder:NSLocalizedString(@"me2DAY ID", @"")];
                    [mUserIDField setDelegate:self];
                }
                else if ([aIndexPath row] == 1)
                {
                    [sCell setTitleText:NSLocalizedString(@"User Key", @"")];

                    mUserKeyField = [sCell textField];
                    [mUserKeyField setKeyboardType:UIKeyboardTypeNamePhonePad];
                    [mUserKeyField setReturnKeyType:UIReturnKeyDone];
                    [mUserKeyField setPlaceholder:NSLocalizedString(@"me2API User Key", @"")];
                    [mUserKeyField setDelegate:self];
                }
                break;

            case 1:
                sCell = [METableViewCellFactory detailCellForTableView:aTableView];
                [[sCell textLabel] setText:NSLocalizedString(@"Passcode Lock", @"")];
                [[sCell detailTextLabel] setText:NSLocalizedString(([mClient hasPasscode] ? @"On" : @"Off"), @"")];
                [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                break;
        }
    }

    return sCell;
}


#pragma mark -
#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    UIViewController *sViewController = nil;

    if ([mClient userID])
    {
        if ([aIndexPath section] == 0)
        {
            [self deleteAccount];
            [mTableView deselectRowAtIndexPath:aIndexPath animated:YES];
        }
        else if ([aIndexPath section] == 2)
        {
            if ([mClient hasPasscode])
            {
                sViewController = [[MEPasscodeSettingsViewController alloc] initWithClient:mClient];
            }
            else
            {
                sViewController = [[MEPasscodeViewController alloc] initWithClient:mClient mode:kMEPasscodeModeChange delegate:self];
                [sViewController setTitle:NSLocalizedString(@"Setup Passcode", @"")];
            }
        }
    }
    else
    {
        if ([aIndexPath section] == 1)
        {
            if ([mClient hasPasscode])
            {
                sViewController = [[MEPasscodeSettingsViewController alloc] initWithClient:mClient];
            }
            else
            {
                sViewController = [[MEPasscodeViewController alloc] initWithClient:mClient mode:kMEPasscodeModeChange delegate:self];
                [sViewController setTitle:NSLocalizedString(@"Setup Passcode", @"")];
            }
        }
    }

    if (sViewController)
    {
        [[self navigationController] pushViewController:sViewController animated:YES];
        [sViewController release];
    }
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    if (aTextField == mUserIDField)
    {
        [mUserKeyField becomeFirstResponder];
    }
    else
    {
        [aTextField resignFirstResponder];
    }

    return YES;
}


#pragma mark -
#pragma mark UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)aActionSheet didDismissWithButtonIndex:(NSInteger)aButtonIndex
{
    if (aButtonIndex != [aActionSheet cancelButtonIndex])
    {
        [MEClientStore removeClientForUserID:[mClient userID]];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}


@end
