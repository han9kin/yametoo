/*
 *  MEMediaView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 27.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEImageView;


@interface MEMediaView : UIView
{
    NSURL                   *mPhotoURL;
    UIActivityIndicatorView *mIndicator;
    UIView                  *mFrameView;
    MEImageView             *mImageView;
    UIButton                *mCloseButton;
    
    CGRect                   mImageRect;
}

@property (nonatomic, copy) NSURL *photoURL;

@end
