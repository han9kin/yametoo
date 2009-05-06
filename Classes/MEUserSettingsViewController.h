/*
 *  MEUserSettingsViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 16.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEUserSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mTableView;
}

@end
