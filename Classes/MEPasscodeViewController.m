/*
 *  MEPasscodeViewController.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEPasscodeViewController.h"
#import "MEClient.h"
#import "MEImageCache.h"


@interface MEPasscodeField : UITextField
{
}

@end

@implementation MEPasscodeField

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];

    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setBorderStyle:UITextBorderStyleBezel];
        [self setClearButtonMode:UITextFieldViewModeNever];
        [self setFont:[UIFont boldSystemFontOfSize:30.0]];
        [self setTextAlignment:UITextAlignmentCenter];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self setSecureTextEntry:YES];
    }

    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return NO;
}

- (void)place
{
    [self setText:@"."];
}

- (void)clear
{
    [self setText:nil];
}

@end


@implementation MEPasscodeViewController


- (id)initWithClient:(MEClient *)aClient mode:(MEPasscodeViewMode)aMode delegate:(id)aDelegate
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mPasscodeFields = [[NSMutableArray alloc] initWithCapacity:4];
        mClient         = [aClient retain];
        mMode           = aMode;
        mDelegate       = aDelegate;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [mCancelButton removeFromSuperview];

    [mPasscodeFields release];
    [mKeyboardLockView release];
    [mCancelButton release];
    [mPasscode release];
    [mClient release];

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

    [[self view] setBackgroundColor:[UIColor lightGrayColor]];

    UITextField *sTextField;
    int          i;

    for (i = 0; i < 4; i++)
    {
        sTextField = [[MEPasscodeField alloc] initWithFrame:CGRectMake(40 + 60 * i, 140, 50, 50)];
        [[self view] addSubview:sTextField];
        [mPasscodeFields addObject:sTextField];
        [sTextField release];
    }

    mTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [mTitleView setBackgroundColor:[UIColor darkGrayColor]];
    [[self view] addSubview:mTitleView];
    [mTitleView release];

    mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 29)];
    [mTitleLabel setBackgroundColor:[UIColor clearColor]];
    [mTitleLabel setFont:[UIFont boldSystemFontOfSize:24.0]];
    [mTitleLabel setTextAlignment:UITextAlignmentCenter];
    [mTitleLabel setTextColor:[UIColor whiteColor]];
    [mTitleLabel setText:NSLocalizedString(@"Enter Passcode", @"")];
    [mTitleView addSubview:mTitleLabel];
    [mTitleLabel release];

    mDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 300, 21)];
    [mDescLabel setBackgroundColor:[UIColor clearColor]];
    [mDescLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [mDescLabel setTextAlignment:UITextAlignmentCenter];
    [mDescLabel setTextColor:[UIColor whiteColor]];
    [mTitleView addSubview:mDescLabel];
    [mDescLabel release];

    sTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 200, 100, 31)];
    [sTextField setClearButtonMode:UITextFieldViewModeNever];
    [sTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [sTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [sTextField setEnablesReturnKeyAutomatically:YES];
    [sTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [sTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [sTextField setReturnKeyType:UIReturnKeyDefault];
    [sTextField setSecureTextEntry:YES];
    [sTextField setHidden:YES];
    [sTextField setDelegate:self];
    [[self view] addSubview:sTextField];
    [sTextField becomeFirstResponder];
    [sTextField release];

    mCancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [mCancelButton setFrame:CGRectMake(0, 163, 106, 53)];
    [mCancelButton setFont:[UIFont boldSystemFontOfSize:12.0]];
    [mCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [mCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mCancelButton setBackgroundImage:[UIImage imageNamed:@"keypad_highlighted.png"] forState:UIControlStateHighlighted];
    [mCancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}


- (void)lockEditingWithAlert:(BOOL)aAlert
{
    if (!mKeyboardLockView)
    {
        NSArray  *sWindows = [[UIApplication sharedApplication] windows];
        UIWindow *sWindow;

        for (sWindow in sWindows)
        {
            if (sWindow != [[self view] window])
            {
                mKeyboardLockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
                [sWindow addSubview:mKeyboardLockView];
                [mKeyboardLockView release];
                break;
            }
        }
    }

    if (aAlert)
    {
        [UIView beginAnimations:@"LockEditingAnimation" context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(unlockEditing)];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationRepeatCount:2];
        [mTitleView setBackgroundColor:[UIColor redColor]];
        [UIView commitAnimations];
    }
    else
    {
        [self performSelector:@selector(unlockEditing) withObject:nil afterDelay:0.5];
    }
}

- (void)unlockEditing
{
    [mTitleView setBackgroundColor:[UIColor darkGrayColor]];
    [mPasscodeFields makeObjectsPerformSelector:@selector(clear)];
    [mKeyboardLockView removeFromSuperview];
    mKeyboardLockView = nil;
}


- (void)passcodeDidChange:(UITextField *)aTextField
{
    NSString   *sPasscode;
    NSUInteger  sLength;

    sPasscode = [aTextField text];
    sLength   = [sPasscode length];
    sLength   = (sLength > 4) ? 4 : sLength;

    [[mPasscodeFields subarrayWithRange:NSMakeRange(0, sLength)] makeObjectsPerformSelector:@selector(place)];
    [[mPasscodeFields subarrayWithRange:NSMakeRange(sLength, 4 - sLength)] makeObjectsPerformSelector:@selector(clear)];

    if (sLength == 4)
    {
        if (mMode == kMEPasscodeViewModeAuthenticate)
        {
            if ([mClient checkPasscode:sPasscode])
            {
                [mDelegate passcodeViewController:self didFinishAuthenticationClient:mClient];
            }
            else
            {
                [mTitleLabel setText:NSLocalizedString(@"Wrong Passcode", @"")];
                [mDescLabel setText:NSLocalizedString(@"try again", @"")];
                [self lockEditingWithAlert:YES];
            }
        }
        else
        {
            if (mPasscode)
            {
                if ([mPasscode isEqualToString:sPasscode])
                {
                    [mClient setPasscode:mPasscode];
                    [mDelegate passcodeViewController:self didFinishChangingPasscodeClient:mClient];
                }
                else
                {
                    [mTitleLabel setText:NSLocalizedString(@"Passcode Mismatch", @"")];
                    [mDescLabel setText:NSLocalizedString(@"enter passcode again", @"")];
                    [self lockEditingWithAlert:YES];
                }

                [mPasscode release];
                mPasscode = nil;
            }
            else
            {
                [mTitleLabel setText:NSLocalizedString(@"Re-enter Passcode", @"")];
                [mDescLabel setText:nil];
                [self lockEditingWithAlert:NO];

                mPasscode = [sPasscode copy];
            }
        }

        [aTextField setText:nil];
    }
}

- (void)cancelButtonTapped
{
    if (mMode == kMEPasscodeViewModeAuthenticate)
    {
        [mDelegate passcodeViewController:self didCancelAuthenticationClient:mClient];
    }
    else
    {
        [mDelegate passcodeViewController:self didCancelChangingPasscodeClient:mClient];
    }
}


#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)aRange replacementString:(NSString *)aString
{
    [self performSelector:@selector(passcodeDidChange:) withObject:aTextField afterDelay:0];
    return YES;
}


#pragma mark UIKeyboradNotifications

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSArray  *sWindows = [[UIApplication sharedApplication] windows];
    UIWindow *sWindow;
    UIView   *sView;

    for (sWindow in sWindows)
    {
        if (sWindow != [[self view] window])
        {
            for (sView in [sWindow subviews])
            {
                if ([NSStringFromClass([sView class]) hasPrefix:@"UIKeyboard"])
                {
                    [sView addSubview:mCancelButton];
                    break;
                }
            }
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [mCancelButton removeFromSuperview];
}


@end