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
    NSString *mHomepageURLStr;
}

@property (nonatomic, copy)     NSString *userID;
@property (nonatomic, copy)     NSString *nickname;
@property (nonatomic, readonly) UIImage  *faceImage;
@property (nonatomic, copy)     NSString *homepageURLStr;

- (void)downloadFaceImage:(NSURL *)aFaceImageURL;

@end
