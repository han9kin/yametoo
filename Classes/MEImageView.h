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
    NSURL               *mURL;
    UIImage             *mImage;
    NSMutableDictionary *mUserInfo;
}

@property(nonatomic, readonly) NSMutableDictionary *userInfo;

- (void)setImageWithURL:(NSURL *)aURL;

@end
