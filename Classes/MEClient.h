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
@class MEUser;


@protocol MEClientDelegate

- (void)client:(MEClient *)aClient didLoadImage:(UIImage *)aImage key:(NSString *)aKey error:(NSError *)aError;

- (void)client:(MEClient *)aClient didLoginWithError:(NSError *)aError;
- (void)client:(MEClient *)aClient didCreatePostWithError:(NSError *)aError;
- (void)client:(MEClient *)aClient didCreateCommentWithError:(NSError *)aError;
- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts error:(NSError *)aError;
- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError;

@end


@interface MEClient : NSObject
{
    NSString *mUserID;
    NSString *mAuthKey;
    NSString *mPasscode;
}

@property (nonatomic, readonly) NSString *userID;
@property (nonatomic, copy)     NSString *passcode;


- (void)loadImageWithURL:(NSURL *)aURL key:(id)aKey delegate:(id)aDelegate;

- (void)loginWithUserID:(NSString *)aUserID userKey:(NSString *)aUserKey delegate:(id)aDelegate;
- (void)createPostWithBody:(NSString *)aBody tags:(NSString *)aTags icon:(NSInteger)aIcon attachedImage:(UIImage *)aImage delegate:(id)aDelegate;
- (void)createCommentWithPostID:(NSString *)aPostID body:(NSString *)aBody delegate:(id)aDelegate;
- (void)getPostsWithUserID:(NSString *)aUserID offset:(NSInteger)aOffset count:(NSInteger)aCount delegate:(id)aDelegate;
- (void)getPersonWithUserID:(NSString *)aUserID delegate:(id)aDelegate;

@end
