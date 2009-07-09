/*
 *  MECommentTableViewCell.h
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 09.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


#define kCommentBodyWidth 240


@class MEComment;
@class MEImageButton;
@class MEAttributedLabel;

@interface MECommentTableViewCell : UITableViewCell
{
    MEImageButton     *mFaceImageButton;
    MEAttributedLabel *mBodyLabel;
    UILabel           *mAuthorLabel;
    UILabel           *mDateLabel;
}

+ (MECommentTableViewCell *)cellForTableView:(UITableView *)aTableView withTarget:(id)aTarget;

- (void)setComment:(MEComment *)aComment;

@end
