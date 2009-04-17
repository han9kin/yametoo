/*
 *  MEUserViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 16.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEUserViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mTableView;
}

@end
