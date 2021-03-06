/*
 *  MEImageView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 21.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


#define NOOutlet


@interface MEImageView : UIView
{
    NSURL       *mURL;
    UIColor     *mBorderColor;
    UIImageView *mImageView;

    NOOutlet id  mDelegate;
}

@property(nonatomic, retain) UIColor *borderColor;
@property(nonatomic, assign) id       delegate;


- (void)setImageWithURL:(NSURL *)aURL;

@end


@protocol MEImageViewDelegate

- (void)imageView:(MEImageView *)aImageView didLoadImage:(UIImage *)aImage;

@end
