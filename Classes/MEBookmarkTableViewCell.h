/*
 *  MEBookmarkTableViewCell.h
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 17.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEBookmark;

@interface MEBookmarkTableViewCell : UITableViewCell
{
    MEBookmark *mBookmark;
}

+ (MEBookmarkTableViewCell *)cellForTableView:(UITableView *)aTableView;

- (void)setBookmark:(MEBookmark *)aBookmark;

@end
