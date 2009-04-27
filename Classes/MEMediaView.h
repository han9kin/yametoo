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
    NSURL       *mPhotoURL;
    MEImageView *mImageView;
}

@property (nonatomic, copy) NSURL *photoURL;

@end
