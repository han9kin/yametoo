/*
 *  MEImageView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 21.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEImageView : UIView
{
    NSURL       *mURL;
    UIColor     *mBorderColor;
    UIImageView *mImageView;

    id           mDelegate;
}

@property(nonatomic, retain) UIColor *borderColor;
@property(nonatomic, assign) id       delegate;

- (void)setImageWithURL:(NSURL *)aURL;

@end


@protocol MEImageViewDelegate

- (void)imageView:(MEImageView *)aImageView didLoadImage:(UIImage *)aImage;

@end
