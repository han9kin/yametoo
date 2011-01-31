/*
 *  MEPasscodeSettingsViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 15.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEClient;

@interface MEPasscodeSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mTableView;

    MEClient    *mClient;
}

- (id)initWithClient:(MEClient *)aClient;

@end
