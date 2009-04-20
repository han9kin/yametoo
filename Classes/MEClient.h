/*
 *  MEClient.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


extern NSString *MEClientErrorDomain;


@class MEClient;


@protocol MEClientDelegate

- (void)client:(MEClient *)aClient didLoginWithError:(NSError *)aError;
- (void)client:(MEClient *)aClient didCreatePostWithError:(NSError *)aError;
- (void)client:(MEClient *)aClient didCreateCommentWithError:(NSError *)aError;
- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts withError:(NSError *)aError;

@end


@interface MEClient : NSObject
{
    NSString *mUserID;
    NSString *mAuthKey;
    NSString *mPasscode;
}

@property (nonatomic, readonly) NSString *userID;
@property (nonatomic, copy)     NSString *passcode;


- (void)loginWithUserID:(NSString *)aUserID userKey:(NSString *)aUserKey delegate:(id)aDelegate;
- (void)createPostWithBody:(NSString *)aBody tags:(NSString *)aTags icon:(NSInteger)aIcon attachedImage:(UIImage *)aImage delegate:(id)aDelegate;
- (void)createCommentWithPostID:(NSString *)aPostID body:(NSString *)aBody delegate:(id)aDelegate;
- (void)getPostsWithUserID:(NSString *)aUserID offset:(NSInteger)aOffset count:(NSInteger)aCount delegate:(id)aDelegate;

@end
