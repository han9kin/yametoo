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
    NSURL    *mFaceImageURL;
    NSString *mHomepageURLStr;

    UIImage  *mFaceImage;
}

@property (nonatomic, readonly) NSString *userID;
@property (nonatomic, readonly) NSString *nickname;
@property (nonatomic, readonly) NSString *homepageURLStr;
@property (nonatomic, readonly) UIImage  *faceImage;


+ (void)removeUnusedCachedUsers;


- (id)initWithDictionary:(NSDictionary *)aUserDict;

@end
