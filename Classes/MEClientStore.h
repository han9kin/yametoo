/*
 *  MEClientStore.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


extern NSString *MEClientStoreUserListDidChangeNotification;
extern NSString *MEClientStoreCurrentUserDidChangeNotification;


@class MEClient;

@interface MEClientStore : NSObject
{
    NSMutableDictionary *mClientsByUserID;
    MEClient            *mCurrentClient;
}


#pragma mark user authentication

+ (NSArray *)userIDs;
+ (NSString *)passcodeForUserID:(NSString *)aUserID;
+ (void)setCurrentUserID:(NSString *)aUserID;


#pragma mark client access

+ (MEClient *)client;
+ (MEClient *)clientForUserID:(NSString *)aUserID;

+ (NSArray *)clients;

+ (void)addClient:(MEClient *)aClient;
+ (void)removeClientForUserID:(NSString *)aUserID;

@end
