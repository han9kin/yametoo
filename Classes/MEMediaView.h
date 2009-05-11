/*
 *  MEMediaView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 27.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@class MERoundBackView;
@class MEImageView;


@interface MEMediaView : UIView
{
    NSURL                   *mPhotoURL;
    UIActivityIndicatorView *mIndicator;
    
    MERoundBackView         *mBackView;
    MEImageView             *mImageView;

    CGRect                   mImageRect;
}

@property (nonatomic, copy) NSURL *photoURL;

@end
