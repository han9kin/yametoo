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
    NSString *mUserDescription;
    NSString *mHomepageURLString;
    NSString *mPhoneNumber;
    NSString *mEmail;
    NSString *mMessenger;
    NSArray  *mPostIcons;
}

@property(nonatomic, readonly) NSString *userID;
@property(nonatomic, readonly) NSString *nickname;
@property(nonatomic, readonly) NSURL    *faceImageURL;
@property(nonatomic, readonly) NSString *userDescription;
@property(nonatomic, readonly) NSString *homepageURLString;
@property(nonatomic, readonly) NSString *phoneNumber;
@property(nonatomic, readonly) NSString *email;
@property(nonatomic, readonly) NSString *messenger;
@property(nonatomic, readonly) NSArray  *postIcons;


+ (void)removeUnusedCachedUsers;
+ (MEUser *)userWithUserID:(NSString *)aUserID;

- (id)initWithDictionary:(NSDictionary *)aUserDict;


@end
