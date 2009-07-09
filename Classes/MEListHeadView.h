/*
 *  MEListHeadView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEImageView;

@interface MEListHeadView : UIView
{
    MEImageView *mFaceImageView;
    UILabel     *mUserDescLabel;
    UIButton    *mNewPostButton;

    id           mDelegate;
}

+ (MEListHeadView *)listHeadView;

- (void)setDelegate:(id)aDelegate;
- (void)setUserID:(NSString *)aUserID;
- (void)setShowsPostButton:(BOOL)aShowsPostButton;

@end


@protocol MEListHeadViewDelegate

- (void)newPostButtonTapped:(MEListHeadView *)aHeaderView;

@end
