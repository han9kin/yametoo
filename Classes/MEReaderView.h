/*
 *  MEReaderView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MEPost.h"


@interface MEReaderView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *mPostArray;
    UITableView    *mTableView;
}

- (void)addPost:(MEPost *)aPost;

@end
