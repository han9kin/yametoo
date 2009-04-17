/*
 *  MEReaderView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEReaderView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mTableView;
}

@end
