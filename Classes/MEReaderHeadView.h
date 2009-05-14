/*
 *  MEReaderHeadView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEImageView;

@interface MEReaderHeadView : UIView
{
    MEImageView *mFaceImageView;
    UILabel     *mUserDescLabel;
    UIButton    *mNewPostButton;

    id           mDelegate;
}

+ (MEReaderHeadView *)readerHeadView;

- (void)setDelegate:(id)aDelegate;
- (void)setUserID:(NSString *)aUserID;

@end


@protocol MEReaderHeadViewDelegate

- (void)newPostButtonTapped:(MEReaderHeadView *)aHeaderView;

@end
