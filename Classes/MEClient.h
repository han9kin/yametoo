/*
 *  MEClient.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


extern NSString *MEClientErrorDomain;


typedef enum MEClientGetPostsScope
{
    kMEClientGetPostsScopeAll = 0,
    kMEClientGetPostsScopeFriendAll,
    kMEClientGetPostsScopeFriendBest,
    kMEClientGetPostsScopeFriendFollowing,
} MEClientGetPostsScope;


@class MEClient;
@class MEUser;


@protocol MEClientDelegate

@optional

- (void)client:(MEClient *)aClient didLoadImage:(UIImage *)aImage key:(NSString *)aKey error:(NSError *)aError;

- (void)client:(MEClient *)aClient didLoginWithError:(NSError *)aError;
- (void)client:(MEClient *)aClient didCreateCommentWithError:(NSError *)aError;
- (void)client:(MEClient *)aClient didCreatePostWithError:(NSError *)aError;
- (void)client:(MEClient *)aClient didGetComments:(NSArray *)aComments error:(NSError *)aError;
- (void)client:(MEClient *)aClient didGetFriends:(NSArray *)aUsers error:(NSError *)aError;
- (void)client:(MEClient *)aClient didGetMetoos:(NSArray *)aUsers error:(NSError *)aError;
- (void)client:(MEClient *)aClient didGetPerson:(MEUser *)aUser error:(NSError *)aError;
- (void)client:(MEClient *)aClient didGetPosts:(NSArray *)aPosts error:(NSError *)aError;
- (void)client:(MEClient *)aClient didMetooWithError:(NSError *)aError;

@end


@interface MEClient : NSObject
{
    NSString            *mUserID;
    NSString            *mAuthKey;
    NSString            *mPasscode;

    NSOperationQueue    *mOperationQueue;
    NSMutableDictionary *mQueuedOperations;
}

@property(nonatomic, readonly) NSString *userID;


+ (void)beginNetworkOperation;
+ (void)endNetworkOperation;


- (void)setPasscode:(NSString *)aPasscode;
- (BOOL)checkPasscode:(NSString *)aPasscode;
- (BOOL)hasPasscode;


- (void)cancelAllOperations;

- (void)loadImageWithURL:(NSURL *)aURL key:(id)aKey delegate:(id)aDelegate;

- (void)loginWithUserID:(NSString *)aUserID userKey:(NSString *)aUserKey delegate:(id)aDelegate;
- (void)createCommentWithPostID:(NSString *)aPostID body:(NSString *)aBody delegate:(id)aDelegate;
- (void)createPostWithBody:(NSString *)aBody tags:(NSString *)aTags icon:(NSInteger)aIcon attachedImage:(UIImage *)aImage delegate:(id)aDelegate;
- (void)getCommentsWithPostID:(NSString *)aPostID delegate:(id)aDelegate;
- (void)getFriendsWithUserID:(NSString *)aUserID delegate:(id)aDelegate;
- (void)getMetoosWithPostID:(NSString *)aPostID delegate:(id)aDelegate;
- (void)getPersonWithUserID:(NSString *)aUserID delegate:(id)aDelegate;
- (void)getPostWithPostID:(NSString *)aPostID delegate:(id)aDelegate;
- (void)getPostsWithUserID:(NSString *)aUserID scope:(MEClientGetPostsScope)aScope offset:(NSInteger)aOffset count:(NSInteger)aCount delegate:(id)aDelegate;
- (void)metooWithPostID:(NSString *)aPostID delegate:(id)aDelegate;

@end
