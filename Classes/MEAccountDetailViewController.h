/*
 *  MEAccountDetailViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEAccountDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
    UITableView      *mTableView;
    UITextField      *mUserIDField;
    UITextField      *mUserKeyField;
    UISwitch         *mPasscodeSwitch;

    NSString         *mUserID;
}

- (id)initWithUserID:(NSString *)aUserID;

@end
