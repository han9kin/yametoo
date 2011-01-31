/*
 *  MEPasscodeViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 28.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


typedef enum MEPasscodeViewMode
{
    kMEPasscodeModeAuthenticate,
    kMEPasscodeModeChange,
} MEPasscodeViewMode;


@class MEClient;
@class MEPasscodeViewController;

@protocol MEPasscodeViewControllerDelegate

- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishAuthenticateClient:(MEClient *)aClient;
- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishChangeClient:(MEClient *)aClient;

@end


@interface MEPasscodeViewController : UIViewController <UITextFieldDelegate>
{
    UILabel            *mPromptLabel;
    UILabel            *mErrorLabel;
    UITextField        *mTextField;
    UIView             *mPasscodeView;
    NSMutableArray     *mPasscodeFields;
    UIWindow           *mLockWindow;

    NSString           *mPasscode;

    MEClient           *mClient;
    MEPasscodeViewMode  mMode;
    BOOL                mAuthenticated;
    id                  mDelegate;
}

- (id)initWithClient:(MEClient *)aClient mode:(MEPasscodeViewMode)aMode delegate:(id)aDelegate;

@end
