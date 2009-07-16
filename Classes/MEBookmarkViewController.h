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
    UITableView *mTableView;
}

@end
