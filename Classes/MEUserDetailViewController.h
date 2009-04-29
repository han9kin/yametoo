/*
 *  MEUserDetailViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEUserDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
    UITableView      *mTableView;
    UITextField      *mUserIDField;
    UITextField      *mUserKeyField;
    UISwitch         *mPasscodeSwitch;

    UIViewController *mParentViewController;

    NSString         *mUserID;
}

- (id)initWithUserID:(NSString *)aUserID parentViewController:(UIViewController *)aParentViewController;

@end
