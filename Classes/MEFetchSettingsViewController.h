/*
 *  MEFetchSettingsViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 06.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEFetchSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mTableView;
    NSInteger    mType;
}

- (id)initWithType:(NSInteger)aType;

@end
