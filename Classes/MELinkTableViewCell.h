/*
 *  MELinkTableViewCell.h
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 05.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MELink;

@interface MELinkTableViewCell : UITableViewCell
{
    UILabel *mTitleLabel;
    UILabel *mURLLabel;
    MELink  *mLink;
}

+ (MELinkTableViewCell *)cellForTableView:(UITableView *)aTableView;

- (void)setLink:(MELink *)aLink;

@end
