/*
 *  MELoginViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 20.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MELoginViewController : UIViewController
{
    UITableView *mTableView;

    BOOL         mDismissAfterLogin;
}

@property(nonatomic, assign) IBOutlet UITableView *tableView;


@end
