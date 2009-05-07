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
    id                   mDelegate;
    NSURL               *mURL;
    UIImage             *mImage;
    NSMutableDictionary *mUserInfo;
}

@property(nonatomic, assign)   id                   delegate;
@property(nonatomic, readonly) NSMutableDictionary *userInfo;

- (void)setImageWithURL:(NSURL *)aURL;

@end


@protocol MEImageViewDelegate

- (void)imageView:(MEImageView *)aImageView imageDidLoad:(UIImage *)aImage;

@end
