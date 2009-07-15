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


@interface MEPasscodeViewController (Private)
@end

@implementation MEPasscodeViewController (Private)

- (void)layoutViewsForInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    switch (aInterfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            [mPromptLabel setFrame:CGRectMake(40, 5, 400, 21)];
            [mPasscodeView setFrame:CGRectMake(125, 30, 230, 50)];
            [mErrorLabel setFrame:CGRectMake(40, 82, 400, 21)];
            break;

        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            [mPromptLabel setFrame:CGRectMake(10, 30, 300, 21)];
            [mPasscodeView setFrame:CGRectMake(45, 70, 230, 50)];
            [mErrorLabel setFrame:CGRectMake(10, 150, 300, 21)];
            break;
    }
}

@end


@implementation MEPasscodeViewController


- (id)initWithClient:(MEClient *)aClient mode:(MEPasscodeViewMode)aMode delegate:(id)aDelegate
{
    self = [super initWithNibName:nil bundle:nil];

    if (self)
    {
        mPasscodeFields = [[NSMutableArray alloc] initWithCapacity:4];
        mClient         = aClient;
        mMode           = aMode;
        mDelegate       = aDelegate;
    }

    return self;
}

- (void)dealloc
{
    [mLockWindow release];
    [mPasscodeFields release];
    [mPasscode release];

    [super dealloc];
}


- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

    UITextField *sTextField;
    int          i;

    mPasscodeView = [[UIView alloc] initWithFrame:CGRectMake(45, 70, 230, 50)];
    [[self view] addSubview:mPasscodeView];
    [mPasscodeView release];

    for (i = 0; i < 4; i++)
    {
        sTextField = [[MEPasscodeField alloc] initWithFrame:CGRectMake(60 * i, 0, 50, 50)];
        [mPasscodeView addSubview:sTextField];
        [mPasscodeFields addObject:sTextField];
        [sTextField release];
    }

    mPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 300, 21)];
    [mPromptLabel setBackgroundColor:[UIColor clearColor]];
    [mPromptLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [mPromptLabel setTextAlignment:UITextAlignmentCenter];
    [mPromptLabel setTextColor:[UIColor darkGrayColor]];
    [mPromptLabel setShadowColor:[UIColor whiteColor]];
    [mPromptLabel setShadowOffset:CGSizeMake(0, 1)];
    [[self view] addSubview:mPromptLabel];
    [mPromptLabel release];

    mErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 300, 21)];
    [mErrorLabel setBackgroundColor:[UIColor clearColor]];
    [mErrorLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [mErrorLabel setTextAlignment:UITextAlignmentCenter];
    [mErrorLabel setTextColor:[UIColor redColor]];
    [mErrorLabel setShadowColor:[UIColor whiteColor]];
    [mErrorLabel setShadowOffset:CGSizeMake(0, 1)];
    [[self view] addSubview:mErrorLabel];
    [mErrorLabel release];

    mTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [mTextField setClearButtonMode:UITextFieldViewModeNever];
    [mTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [mTextField setEnablesReturnKeyAutomatically:YES];
    [mTextField setKeyboardType:UIKeyboardTypeNumberPad];
    [mTextField setReturnKeyType:UIReturnKeyDone];
    [mTextField setSecureTextEntry:YES];
    [mTextField setHidden:YES];
    [mTextField setDelegate:self];
    [[self view] addSubview:mTextField];
    [mTextField becomeFirstResponder];
    [mTextField release];

    [self layoutViewsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];

    if (mMode == kMEPasscodeModeAuthenticate)
    {
        [mPromptLabel setText:NSLocalizedString(@"Enter Passcode", @"")];
    }
    else
    {
        if ([mClient hasPasscode])
        {
            [mPromptLabel setText:NSLocalizedString(@"Enter Current Passcode", @"")];
        }
        else
        {
            [mPromptLabel setText:NSLocalizedString(@"Enter New Passcode", @"")];
            mAuthenticated = YES;
        }
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation duration:(NSTimeInterval)aDuration
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:aDuration];
    [self layoutViewsForInterfaceOrientation:aInterfaceOrientation];
    [UIView commitAnimations];
}


- (void)didFinish
{
    if (mMode == kMEPasscodeModeAuthenticate)
    {
        [mDelegate passcodeViewController:self didFinishAuthenticateClient:mClient];
    }
    else
    {
        [mDelegate passcodeViewController:self didFinishChangeClient:mClient];
    }
}


- (void)lockFields
{
    mLockWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [mLockWindow setBackgroundColor:[UIColor clearColor]];
    [mLockWindow setWindowLevel:UIWindowLevelAlert];
    [mLockWindow makeKeyAndVisible];

    [self performSelector:@selector(unlockFields) withObject:nil afterDelay:0.1];
}

- (void)unlockFields
{
    [mLockWindow release];
    mLockWindow = nil;

    [mTextField setText:nil];
    [mPasscodeFields makeObjectsPerformSelector:@selector(clear)];
}


- (void)passcodeDidChange
{
    NSString   *sPasscode;
    NSUInteger  sLength;
    BOOL        sFinish;

    sPasscode = [mTextField text];
    sLength   = [sPasscode length];
    sLength   = (sLength > 4) ? 4 : sLength;
    sFinish   = NO;

    [[mPasscodeFields subarrayWithRange:NSMakeRange(0, sLength)] makeObjectsPerformSelector:@selector(place)];
    [[mPasscodeFields subarrayWithRange:NSMakeRange(sLength, 4 - sLength)] makeObjectsPerformSelector:@selector(clear)];

    if (sLength == 4)
    {
        if (mMode == kMEPasscodeModeAuthenticate)
        {
            if ([mClient checkPasscode:sPasscode])
            {
                sFinish = YES;
            }
            else
            {
                [mErrorLabel setText:NSLocalizedString(@"wrong passcode", @"")];
            }
        }
        else
        {
            if (mPasscode)
            {
                if ([mPasscode isEqualToString:sPasscode])
                {
                    [mClient setPasscode:mPasscode];
                    sFinish = YES;
                }
                else
                {
                    [mPromptLabel setText:NSLocalizedString(@"Enter New Passcode", @"")];
                    [mErrorLabel setText:NSLocalizedString(@"passcode mismatch", @"")];
                }

                [mPasscode release];
                mPasscode = nil;
            }
            else
            {
                if (mAuthenticated)
                {
                    [mPromptLabel setText:NSLocalizedString(@"Re-enter New Passcode", @"")];
                    [mErrorLabel setText:nil];

                    mPasscode = [sPasscode copy];
                }
                else
                {
                    if ([mClient checkPasscode:sPasscode])
                    {
                        [mPromptLabel setText:NSLocalizedString(@"Enter New Passcode", @"")];
                        [mErrorLabel setText:nil];
                        mAuthenticated = YES;
                    }
                    else
                    {
                        [mErrorLabel setText:NSLocalizedString(@"wrong passcode", @"")];
                    }
                }
            }
        }

        if (sFinish)
        {
            [self performSelector:@selector(didFinish) withObject:nil afterDelay:0];
        }
        else
        {
            [self lockFields];
        }
    }

}


#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)aRange replacementString:(NSString *)aString
{
    [self performSelector:@selector(passcodeDidChange) withObject:nil afterDelay:0];
    return YES;
}


@end
