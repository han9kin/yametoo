/*
 *  MEUser.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MEUser : NSObject
{
    NSString *mUserID;
    NSString *mNickname;
    UIImage  *mFaceImage;
    NSURL    *mHomepageURL;
}

@property (nonatomic, copy)     NSString *userID;
@property (nonatomic, copy)     NSString *nickname;
@property (nonatomic, readonly) UIImage  *faceImage;
@property (nonatomic, copy)     NSURL    *homepageURL;

- (void)downloadFaceImage:(NSURL *)aFaceImageURL;

@end
