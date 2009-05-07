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

    CGFloat            mBodyWidth;
}

+ (CGFloat)heightWithPost:(MEPost *)aPost;

- (void)setPost:(MEPost *)aPost;

@end
