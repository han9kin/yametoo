/*
 *  MEBookmarkTableViewCell.h
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 17.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MELink;

@interface MEBookmarkTableViewCell : UITableViewCell
{
    MELink *mLink;
}

+ (MEBookmarkTableViewCell *)cellForTableView:(UITableView *)aTableView;

- (void)setLink:(MELink *)aLink;

@end
