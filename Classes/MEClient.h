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
- (void)client:(MEClient *)aClient didPostWithError:(NSError *)aError;

@end


@interface MEClient : NSObject
{
    NSString *mUserID;
    NSString *mUserKey;
    NSString *mAuthKey;
}

@property (nonatomic, readonly) NSString *userID;
@property (nonatomic, readonly) NSString *userKey;


- (void)loginWithUserID:(NSString *)aUserID userKey:(NSString *)aUserKey delegate:(id)aDelegate;
- (void)postWithBody:(NSString *)aBody tags:(NSString *)aTags icon:(NSInteger)aIcon attachedImage:(UIImage *)aImage delegate:(id)aDelegate;

@end
