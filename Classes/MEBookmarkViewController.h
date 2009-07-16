/*
 *  MEBookmarkViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 16.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEBookmarkViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UINavigationBar *mNavigationBar;
    UITableView     *mTableView;
}

@property(nonatomic, assign) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic, assign) IBOutlet UITableView     *tableView;


- (IBAction)close;
- (IBAction)edit;

@end
