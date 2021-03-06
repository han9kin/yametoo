/*
 *  MEClientStore.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 17.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MEClientStore.h"
#import "MEClient.h"
#import "ObjCUtil.h"


NSString *MEClientStoreUserListDidChangeNotification    = @"MEClientStoreUserListDidChangeNotification";
NSString *MEClientStoreCurrentUserDidChangeNotification = @"MEClientStoreCurrentUserDidChangeNotification";


static NSString *kClientsKey = @"clients";


@interface MEClientStore (Private)
@end

@implementation MEClientStore (Private)

- (NSArray *)userIDs
{
    return [mClientsByUserID allKeys];
}

- (MEClient *)anyClient
{
    return mAnyClient;
}

- (MEClient *)currentClient
{
    return mCurrentClient;
}

- (void)setCurrentClient:(MEClient *)aClient
{
    if (mCurrentClient != aClient)
    {
        [mCurrentClient cancelAllOperations];

        mCurrentClient = aClient;

        [[NSNotificationCenter defaultCenter] postNotificationName:MEClientStoreCurrentUserDidChangeNotification object:nil];
    }
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

- (NSArray *)clients
{
    return [[mClientsByUserID allValues] sortedArrayUsingSelector:@selector(compareByUserID:)];
}

- (void)addClient:(MEClient *)aClient forUserID:(NSString *)aUserID
{
    if ([[mCurrentClient userID] isEqualToString:aUserID])
    {
        [self setCurrentClient:aClient];
        [mClientsByUserID setObject:aClient forKey:aUserID];
    }
    else
    {
        [mClientsByUserID setObject:aClient forKey:aUserID];
        [aClient getPersonWithUserID:aUserID delegate:nil];
    }

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:mClientsByUserID] forKey:kClientsKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:MEClientStoreUserListDidChangeNotification object:nil];
}

- (void)removeClientForUserID:(NSString *)aUserID
{
    if ([[mCurrentClient userID] isEqualToString:aUserID])
    {
        [self setCurrentClient:nil];
    }

    [mClientsByUserID removeObjectForKey:aUserID];

    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:mClientsByUserID] forKey:kClientsKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:MEClientStoreUserListDidChangeNotification object:nil];
}

@end


@implementation MEClientStore

SYNTHESIZE_SINGLETON_CLASS(MEClientStore, sharedStore);


- (id)init
{
    self = [super init];

    if (self)
    {
        NSData *sData;

        sData = [[NSUserDefaults standardUserDefaults] dataForKey:kClientsKey];

        if (sData)
        {
            mClientsByUserID = [NSKeyedUnarchiver unarchiveObjectWithData:sData];
        }
        else
        {
            mClientsByUserID = nil;
        }

        if (mClientsByUserID)
        {
            mClientsByUserID = [mClientsByUserID mutableCopy];
        }
        else
        {
            mClientsByUserID = [[NSMutableDictionary alloc] init];
        }

        mAnyClient = [[MEClient alloc] init];
    }

    return self;
}

- (void)dealloc
{
    [mClientsByUserID release];
    [mAnyClient release];
    [super dealloc];
}


#pragma mark user authentication

+ (NSArray *)userIDs
{
    return [[self sharedStore] userIDs];
}

+ (void)setCurrentUserID:(NSString *)aUserID
{
    return [[self sharedStore] setCurrentClient:[[self sharedStore] clientForUserID:aUserID]];
}


#pragma mark client access

+ (MEClient *)anyClient
{
    return [[self sharedStore] anyClient];
}

+ (MEClient *)currentClient
{
    return [[self sharedStore] currentClient];
}

+ (MEClient *)clientForUserID:(NSString *)aUserID
{
    return [[self sharedStore] clientForUserID:aUserID];
}

+ (NSArray *)clients
{
    return [[self sharedStore] clients];
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
