/*
 *  MEListHeadView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


#define kListHeadViewHeight 60


@class MEImageView;
@class MEUser;

@interface MEListHeadView : UIView
{
    MEImageView *mFaceImageView;
    UILabel     *mUserIDLabel;
    UILabel     *mUserDescLabel;
}

- (void)setUser:(MEUser *)aUser;

@end
