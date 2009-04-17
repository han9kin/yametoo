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

@interface UINavigationBar (Hack)
+ (CGSize)defaultSize;
@end


@implementation MEUserDetailViewController

- (id)initWithUserID:(NSString *)aUserID parentViewController:(UIViewController *)aParentViewController
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mUserID               = [aUserID copy];
        mParentViewController = aParentViewController;
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

    [[self view] setBackgroundColor:[UIColor whiteColor]];

    UIView  *sView;
    UILabel *sLabel;

    if (mParentViewController)
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

        sBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonTouched)];
        [sNavigationItem setLeftBarButtonItem:sBarButtonItem];
        [sBarButtonItem release];

        sBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"OK", @"") style:UIBarButtonItemStylePlain target:self action:@selector(okButtonTouched)];
        [sNavigationItem setRightBarButtonItem:sBarButtonItem];
        [sBarButtonItem release];

        sView = [[UIView alloc] initWithFrame:CGRectMake(0, 74, 320, 436)];
        [[self view] addSubview:sView];
        [sView release];
    }
    else
    {
        sView = [self view];
    }

    sLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 80, 21)];
    [sLabel setText:NSLocalizedString(@"User ID", @"")];
    [sView addSubview:sLabel];
    [sLabel release];

    mUserIDField = [[UITextField alloc] initWithFrame:CGRectMake(120, 20, 180, 31)];
    [mUserIDField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [mUserIDField setBorderStyle:UITextBorderStyleRoundedRect];
    [mUserIDField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [mUserIDField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mUserIDField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [mUserIDField setEnablesReturnKeyAutomatically:YES];
    [mUserIDField setKeyboardType:UIKeyboardTypeASCIICapable];
    [mUserIDField setReturnKeyType:UIReturnKeyNext];
    [mUserIDField setText:mUserID];
    [mUserIDField setDelegate:self];
    [sView addSubview:mUserIDField];
    [mUserIDField release];

    sLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, 80, 21)];
    [sLabel setText:NSLocalizedString(@"API Key", @"")];
    [sView addSubview:sLabel];
    [sLabel release];

    mUserKeyField = [[UITextField alloc] initWithFrame:CGRectMake(120, 60, 180, 31)];
    [mUserKeyField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [mUserKeyField setBorderStyle:UITextBorderStyleRoundedRect];
    [mUserKeyField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [mUserKeyField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mUserKeyField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [mUserKeyField setEnablesReturnKeyAutomatically:YES];
    [mUserKeyField setKeyboardType:UIKeyboardTypeNumberPad];
    [mUserKeyField setReturnKeyType:UIReturnKeyJoin];
    [mUserKeyField setText:(mUserID ? @"**********" : nil)];
    [mUserKeyField setDelegate:self];
    [sView addSubview:mUserKeyField];
    [mUserKeyField release];

    [mUserIDField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    mUserIDField  = nil;
    mUserKeyField = nil;
}

- (BOOL)hidesBottomBarWhenPushed
{
    return YES;
}


#pragma mark actions

- (void)cancelButtonTouched
{
    [mParentViewController dismissModalViewControllerAnimated:YES];
}

- (void)okButtonTouched
{
    if ([[mUserIDField text] length] && [[mUserKeyField text] length])
    {
        MEClient *sClient;

        sClient = [[MEClient alloc] init];
        [sClient loginWithUserID:[mUserIDField text] userKey:[mUserKeyField text] delegate:self];
    }
    else
    {
        UIAlertView *sAlertView;

        sAlertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please enter required fields", @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [sAlertView show];
        [sAlertView release];
    }
}


#pragma mark MEClientDelegate


- (void)client:(MEClient *)aClient didLoginWithError:(NSError *)aError
{
    if (aError)
    {
        UIAlertView *sAlertView;

        sAlertView = [[UIAlertView alloc] initWithTitle:nil message:[aError localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @""), nil];
        [sAlertView show];
        [sAlertView release];
    }
    else
    {
        [MEClientStore addClient:aClient];
        [MEClientStore setCurrentUserID:[aClient userID]];
        [mParentViewController dismissModalViewControllerAnimated:YES];
    }

    [aClient release];
}


#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    if (aTextField == mUserIDField)
    {
        [mUserKeyField becomeFirstResponder];
    }
    else if (aTextField == mUserKeyField)
    {
        NSLog(@"puhaha");
    }

    return YES;
}


@end
