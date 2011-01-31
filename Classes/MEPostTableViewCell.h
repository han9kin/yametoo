/*
 *  MEPostTableViewCell.h
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 09.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


#define kPostCellBodyTopPadding  9
#define kPostCellBodyLeftPadding 70
#define kPostCellIconPadding     50


@class MEPost;
@class MEImageButton;
@class MEPostBodyView;

@interface MEPostTableViewCell : UITableViewCell
{
    UILabel        *mAuthorLabel;
    MEImageButton  *mFaceImageButton;
    MEImageButton  *mPostImageButton;
    MEPostBodyView *mBodyView;
}

+ (MEPostTableViewCell *)cellForTableView:(UITableView *)aTableView withTarget:(id)aTarget;
+ (MEPostTableViewCell *)cellWithAuthorForTableView:(UITableView *)aTableView withTarget:(id)aTarget;

- (void)setPost:(MEPost *)aPost;

@end
