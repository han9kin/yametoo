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

    [mBackView removeFromSuperview];
    [mKeyboardLockView removeFromSuperview];
    [mCancelButton removeFromSuperview];

    [mPasscodeFields release];
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
    [mTitleView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
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

    mTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 200, 100, 31)];
    [mTextField setClearButtonMode:UITextFieldViewModeNever];
    [mTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [mTextField setEnablesReturnKeyAutomatically:YES];
    [mTextField setKeyboardAppearance:UIKeyboardAppearanceAlert];
    [mTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [mTextField setReturnKeyType:UIReturnKeyDefault];
    [mTextField setSecureTextEntry:YES];
    [mTextField setHidden:YES];
    [mTextField setDelegate:self];
    [[self view] addSubview:mTextField];
    [mTextField becomeFirstResponder];
    [mTextField release];

    mCancelButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [mCancelButton setFrame:CGRectMake(0, 163, 106, 53)];
    [mCancelButton setFont:[UIFont boldSystemFontOfSize:12.0]];
    [mCancelButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    [mCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mCancelButton setBackgroundImage:[UIImage imageNamed:@"keypad_highlighted.png"] forState:UIControlStateHighlighted];
    [mCancelButton addTarget:self action:@selector(cancelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}


- (void)showInView:(UIView *)aView
{
    if (!mBackView)
    {
        mBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [aView frame].size.width, [aView frame].size.height)];
        [mBackView setBackgroundColor:[UIColor clearColor]];
        [aView addSubview:mBackView];
        [mBackView release];
    }

    [[self view] setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [[self view] setFrame:CGRectMake(0, -244, 320, 244)];

    [mTitleView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];

    [mBackView addSubview:[self view]];

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [mBackView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
    [[self view] setFrame:CGRectMake(0, 0, 320, 244)];
    [UIView commitAnimations];
}

- (void)dismiss
{
    if (mBackView)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismissAnimationDidStop:finished:context:)];
        [[self view] setFrame:CGRectMake(0, -244, 320, 244)];
        [mBackView setBackgroundColor:[UIColor clearColor]];
        [UIView commitAnimations];

        [mTextField resignFirstResponder];
    }
    else
    {
        [mDelegate performSelector:mDidEndSelector withObject:self withObject:mClient];
    }
}

- (void)dismissAnimationDidStop:(NSString *)aAnimationID finished:(NSNumber *)aFinished context:(void *)aContext
{
    [mBackView removeFromSuperview];
    [[self view] removeFromSuperview];

    mBackView = nil;

    [mDelegate performSelector:mDidEndSelector withObject:self withObject:mClient];
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
    [mTitleView setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.5]];
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
                mDidEndSelector = @selector(passcodeViewController:didFinishAuthenticationClient:);
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
                    mDidEndSelector = @selector(passcodeViewController:didFinishChangingPasscodeClient:);
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

    if (mDidEndSelector)
    {
        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0];
    }
}

- (void)cancelButtonTapped
{
    if (mMode == kMEPasscodeViewModeAuthenticate)
    {
        mDidEndSelector = @selector(passcodeViewController:didCancelAuthenticationClient:);
    }
    else
    {
        mDidEndSelector = @selector(passcodeViewController:didCancelChangingPasscodeClient:);
    }

    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0];
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
