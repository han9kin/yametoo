/*
 *  MEVisitsViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 09.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MELink;

@interface MEVisitsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UILabel        *mTitleLabel;
    UITableView    *mTableView;

    NSString       *mTitle;
    NSMutableArray *mLinks;
}


+ (MEVisitsViewController *)sharedController;


- (void)visitLink:(MELink *)aLink;


@end
