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
#import "METableViewCellFactory.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MEAccountDetailViewController

- (id)initWithUserID:(NSString *)aUserID
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mUserID = [aUserID copy];

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

    if (mUserID)
    {
        [[self navigationItem] setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(modifyButtonTapped)] autorelease]];
    }
    else
    {
        [[self navigationItem] setPrompt:NSLocalizedString(@"Enter account information", @"")];
        [[self navigationItem] setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addButtonTapped)] autorelease]];
    }

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
    mPasscodeSwitch = nil;
}


- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    [[self navigationController] setNavigationBarHidden:NO animated:aAnimated];
}


- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}


#pragma mark actions

- (void)cancelButtonTapped
{
}

- (void)addButtonTapped
{
    if ([[mUserIDField text] length] && [[mUserKeyField text] length])
    {
        if ([MEClientStore clientForUserID:[mUserIDField text]])
        {
            [UIAlertView showAlert:@"Account already registered."];
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
        [UIAlertView showAlert:@"Please enter required fields."];
    }
}

- (void)modifyButtonTapped
{
    MEClient *sClient;

    if ([[mUserKeyField text] length])
    {
        sClient = [[MEClient alloc] init];
        [sClient loginWithUserID:mUserID userKey:[mUserKeyField text] delegate:self];
    }
    else
    {
        sClient = [MEClientStore clientForUserID:mUserID];

        if ([mPasscodeSwitch isOn])
        {
            UIViewController *sViewController;

            sViewController = [[MEPasscodeViewController alloc] initWithClient:sClient mode:kMEPasscodeViewModeChange delegate:self];
            [self presentModalViewController:sViewController animated:NO];
            [sViewController release];
        }
        else
        {
            [sClient setPasscode:nil];
            [MEClientStore addClient:sClient];

            [[self navigationController] popViewControllerAnimated:YES];
        }
    }
}

- (void)deleteButtonTapped
{
    UIActionSheet *sActionSheet;
    NSString      *sTitle;

    sTitle = [NSString stringWithFormat:NSLocalizedString(@"Delete account \"%@\".", @""), mUserID];

    sActionSheet = [[UIActionSheet alloc] initWithTitle:sTitle delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete Account", @"") otherButtonTitles:nil];
    [sActionSheet showInView:[self view]];
    [sActionSheet release];
}


#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didLoginWithError:(NSError *)aError
{
    if (aError)
    {
        [UIAlertView showError:aError];
    }
    else
    {
        if ([mPasscodeSwitch isOn])
        {
            UIViewController *sViewController;

            sViewController = [[MEPasscodeViewController alloc] initWithClient:aClient mode:kMEPasscodeViewModeChange delegate:self];
            [self presentModalViewController:sViewController animated:NO];
            [sViewController release];
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

    [aClient release];
}


#pragma mark MEPasscodeViewControllerDelegate


- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishChangingPasscodeClient:(MEClient *)aClient
{
    [MEClientStore addClient:aClient];

    if (![MEClientStore currentClient])
    {
        [MEClientStore setCurrentUserID:[aClient userID]];
    }

    [self dismissModalViewControllerAnimated:NO];

    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didCancelChangingPasscodeClient:(MEClient *)aClient
{
    [self dismissModalViewControllerAnimated:NO];

    if (mUserIDField)
    {
        [mUserIDField becomeFirstResponder];
    }
    else
    {
        [mUserKeyField becomeFirstResponder];
    }
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

    if (mUserID)
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
                [mUserKeyField setReturnKeyType:UIReturnKeyJoin];
                [mUserKeyField setPlaceholder:NSLocalizedString(@"me2API User Key", @"")];
                [mUserKeyField setDelegate:self];
                [mUserKeyField becomeFirstResponder];
                break;

            case 2:
                sCell = [METableViewCellFactory switchCellForTableView:aTableView];
                [[sCell textLabel] setText:NSLocalizedString(@"Passcode Lock", @"")];

                mPasscodeSwitch = [sCell switch];
                [mPasscodeSwitch setOn:[[MEClientStore clientForUserID:mUserID] hasPasscode]];
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
                    [mUserIDField becomeFirstResponder];
                }
                else if ([aIndexPath row] == 1)
                {
                    [sCell setTitleText:NSLocalizedString(@"User Key", @"")];

                    mUserKeyField = [sCell textField];
                    [mUserKeyField setKeyboardType:UIKeyboardTypeNamePhonePad];
                    [mUserKeyField setReturnKeyType:UIReturnKeyJoin];
                    [mUserKeyField setPlaceholder:NSLocalizedString(@"me2API User Key", @"")];
                    [mUserKeyField setDelegate:self];
                }
                break;

            case 1:
                sCell = [METableViewCellFactory switchCellForTableView:aTableView];
                [[sCell textLabel] setText:NSLocalizedString(@"Passcode Lock", @"")];

                mPasscodeSwitch = [sCell switch];
                [mPasscodeSwitch setOn:YES];
                break;
        }
    }

    return sCell;
}


#pragma mark UITableViewDelegate


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    if (mUserID && ([aIndexPath section] == 0))
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


#pragma mark UIActionSheetDelegate


- (void)actionSheet:(UIActionSheet *)aActionSheet didDismissWithButtonIndex:(NSInteger)aButtonIndex
{
    if (aButtonIndex != [aActionSheet cancelButtonIndex])
    {
        [MEClientStore removeClientForUserID:mUserID];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}


@end
