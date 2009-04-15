/*
 *  MEClient.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MEClient : NSObject
{
    NSString     *mBaseURL;
    NSString     *mNonce;
    NSString     *mAppKey;
    NSString     *mUserKey;
    NSString     *mUserID;
    
    NSDictionary *mAPIURLDict;
}

@property (nonatomic, retain) NSString *nonce;
@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *userKey;
@property (nonatomic, retain) NSString *userID;

- (NSString *)authKey;

@end
