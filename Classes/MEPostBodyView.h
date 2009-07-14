/*
 *  MEPostBodyView.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 30.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEAttributedLabel;
@class MEPost;

@interface MEPostBodyView : UIView
{
    MEAttributedLabel *mBodyLabel;
    UILabel           *mTagsLabel;
    UILabel           *mTimeLabel;
    UILabel           *mCommentsLabel;

    BOOL               mShowsPostDate;
}

@property(nonatomic, assign) BOOL showsPostDate;


+ (CGFloat)heightWithPost:(MEPost *)aPost forWidth:(CGFloat)aWidth;

- (void)setPost:(MEPost *)aPost;

@end
