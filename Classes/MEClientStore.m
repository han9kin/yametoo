/*
 *  MEClientStore.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEClientStore.h"
#import "MEClient.h"
#import "ObjCUtil.h"


@interface MEClientStore (Private)
@end

@implementation MEClientStore (Private)

- (NSArray *)userIDs
{
    return [mClientsByUserID allKeys];
}

- (MEClient *)clientForUserID:(NSString *)aUserID
{
    if (aUserID)
    {
        return [mClientsByUserID objectForKey:aUserID];
    }
    else
    {
        return nil;
    }
}

- (void)addClient:(MEClient *)aClient forUserID:(NSString *)aUserID
{
    [mClientsByUserID setObject:aClient forKey:aUserID];
}

- (void)removeClientForUserID:(NSString *)aUserID
{
    if ([[mCurrentClient userID] isEqualToString:aUserID])
    {
        mCurrentClient = nil;
    }

    [mClientsByUserID removeObjectForKey:aUserID];
}

- (MEClient *)currentClient
{
    return mCurrentClient;
}

- (void)setCurrentClient:(MEClient *)aClient
{
    mCurrentClient = aClient;
}

@end


@implementation MEClientStore

SYNTHESIZE_SINGLETON_CLASS(MEClientStore, sharedStore);


- (id)init
{
    self = [super init];

    if (self)
    {
        mClientsByUserID = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)dealloc
{
    [mClientsByUserID release];
    [super dealloc];
}


#pragma mark user authentication

+ (NSArray *)userIDs
{
    return [[self sharedStore] userIDs];
}

+ (NSString *)passcodeForUserID:(NSString *)aUserID
{
    return [[[self sharedStore] clientForUserID:aUserID] passcode];
}

+ (void)setCurrentUserID:(NSString *)aUserID
{
    return [[self sharedStore] setCurrentClient:[[self sharedStore] clientForUserID:aUserID]];
}


#pragma mark client access

+ (MEClient *)client
{
    return [[self sharedStore] currentClient];
}

+ (MEClient *)clientForUserID:(NSString *)aUserID
{
    return [[self sharedStore] clientForUserID:aUserID];
}

+ (void)addClient:(MEClient *)aClient
{
    [[self sharedStore] addClient:aClient forUserID:[aClient userID]];
}

+ (void)removeClientForUserID:(NSString *)aUserID
{
    [[self sharedStore] removeClientForUserID:aUserID];
}

@end
