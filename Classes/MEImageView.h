/*
 *  MEImageView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 21.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEImageView : UIControl
{
    NSURL   *mURL;
    UIImage *mImage;

    id       mDelegate;
    id       mUserInfo;
}

@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) id userInfo;


- (void)setImageWithURL:(NSURL *)aURL;

@end


@protocol MEImageViewDelegate

- (void)imageView:(MEImageView *)aImageView imageDidLoad:(UIImage *)aImage;

@end
