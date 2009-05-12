/*
 *  MEPasscodeViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


typedef enum MEPasscodeViewMode
{
    kMEPasscodeViewModeAuthenticate,
    kMEPasscodeViewModeChange,
} MEPasscodeViewMode;


@class MEClient;
@class MEPasscodeViewController;

@protocol MEPasscodeViewControllerDelegate

- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishAuthenticationClient:(MEClient *)aClient;
- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didCancelAuthenticationClient:(MEClient *)aClient;

- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didFinishChangingPasscodeClient:(MEClient *)aClient;
- (void)passcodeViewController:(MEPasscodeViewController *)aViewController didCancelChangingPasscodeClient:(MEClient *)aClient;

@end


@interface MEPasscodeViewController : UIViewController <UITextFieldDelegate>
{
    UIView             *mBackView;
    UIView             *mTitleView;
    UILabel            *mTitleLabel;
    UILabel            *mDescLabel;
    UITextField        *mTextField;
    NSMutableArray     *mPasscodeFields;
    UIView             *mKeyboardLockView;
    UIButton           *mCancelButton;

    NSString           *mPasscode;

    MEClient           *mClient;
    MEPasscodeViewMode  mMode;
    id                  mDelegate;
    SEL                 mDidEndSelector;
}


- (id)initWithClient:(MEClient *)aClient mode:(MEPasscodeViewMode)aMode delegate:(id)aDelegate;

- (void)showInView:(UIView *)aView;

@end
