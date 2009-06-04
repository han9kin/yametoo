/*
 *  MEAccountDetailViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "UIAlertView+MEAdditions.h"
#import "UIViewController+MEAdditions.h"
#import "MEAccountDetailViewController.h"
#import "MEPasscodeViewController.h"
#import "METableViewCellFactory.h"
#import "MEClientStore.h"
#import "MEClient.h"


@implementation MEAccountDetailViewController

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

        sBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(modifyButtonTapped)];
        [[self navigationItem] setRightBarButtonItem:sBarButtonItem];
        [sBarButtonItem release];

        sTableFrame = CGRectMake(0, 0, 320, 416);
    }
    else
    {
        UINavigationBar  *sNavigationBar;
        UINavigationItem *sNavigationItem;
        UIBarButtonItem  *sBarButtonItem;

        sNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 74)];
        [sNavigationBar setBarStyle:UIBarStyleBlackOpaque];
        [[self view] addSubview:sNavigationBar];
        [sNavigationBar release];

        sNavigationItem = [[UINavigationItem alloc] initWithTitle:[self title]];
        [sNavigationItem setPrompt:NSLocalizedString(@"Enter account information", @"")];
        [sNavigationBar pushNavigationItem:sNavigationItem animated:NO];
        [sNavigationItem release];

        sBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonTapped)];
        [sNavigationItem setLeftBarButtonItem:sBarButtonItem];
        [sBarButtonItem release];

        sBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addButtonTapped)];
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

    mTableView      = nil;
    mUserIDField    = nil;
    mUserKeyField   = nil;
    mPasscodeSwitch = nil;
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
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

            [[self navigationController] popViewControllerAnimated:YES];
            [mParentViewController dismissModalViewControllerAnimated:YES];
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
            [mParentViewController dismissModalViewControllerAnimated:YES];
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
    [mParentViewController dismissModalViewControllerAnimated:YES];
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
                [sCell setText:NSLocalizedString(@"Delete this Account", @"")];
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
                [sCell setText:NSLocalizedString(@"Passcode Lock", @"")];

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
                    [mUserIDField setKeyboardType:UIKeyboardTypeASCIICapable];
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
                [sCell setText:NSLocalizedString(@"Passcode Lock", @"")];

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


- (void)actionSheet:(UIActionSheet *)aActionSheet clickedButtonAtIndex:(NSInteger)aButtonIndex
{
    if (aButtonIndex == 0)
    {
        [MEClientStore removeClientForUserID:mUserID];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}


@end
