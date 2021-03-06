/*
 *  MEUser.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@class MEPostIcon;

@interface MEUser : NSObject
{
    NSString   *mUserID;
    NSString   *mNickname;
    NSURL      *mFaceImageURL;
    NSString   *mUserDescription;
    NSString   *mHomepageURLString;
    NSString   *mPhoneNumber;
    NSString   *mEmail;
    NSString   *mMessenger;
    NSArray    *mPostIcons;
    MEPostIcon *mDefaultPostIcon;
}

@property(nonatomic, readonly) NSString   *userID;
@property(nonatomic, readonly) NSString   *nickname;
@property(nonatomic, readonly) NSURL      *faceImageURL;
@property(nonatomic, readonly) NSString   *userDescription;
@property(nonatomic, readonly) NSString   *homepageURLString;
@property(nonatomic, readonly) NSString   *phoneNumber;
@property(nonatomic, readonly) NSString   *email;
@property(nonatomic, readonly) NSString   *messenger;
@property(nonatomic, readonly) NSArray    *postIcons;
@property(nonatomic, readonly) MEPostIcon *defaultPostIcon;


+ (void)removeUnusedCachedUsers;

+ (MEUser *)currentUser;
+ (MEUser *)userWithUserID:(NSString *)aUserID;

- (id)initWithDictionary:(NSDictionary *)aUserDict;


@end
