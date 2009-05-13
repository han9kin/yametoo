/*
 *  MEImageButton.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 08.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEImageButton : UIControl
{
    NSURL       *mURL;
    UIColor     *mBorderColor;
    UIImageView *mImageView;

    id           mUserInfo;
}

@property(nonatomic, retain) UIColor *borderColor;
@property(nonatomic, retain) id       userInfo;


- (void)setImageWithURL:(NSURL *)aURL;

@end
