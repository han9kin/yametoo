/*
 *  MEAccountDetailViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 17.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEClient;

@interface MEAccountDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
    UITableView      *mTableView;
    UITextField      *mUserIDField;
    UITextField      *mUserKeyField;

    MEClient         *mClient;
}

- (id)initWithClient:(MEClient *)aClient;

@end
