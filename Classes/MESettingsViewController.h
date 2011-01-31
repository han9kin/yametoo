/*
 *  MESettingsViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MESettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mTableView;
}

@end
