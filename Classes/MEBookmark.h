/*
 *  MEBookmark.h
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 21.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@class MEUser;
@class MEPost;

@interface MEBookmark : NSObject
{
    NSString *mUserID;
    NSString *mPostID;
    NSDate   *mPostDate;
    NSString *mTitle;
}

@property(nonatomic, readonly) NSString *userID;
@property(nonatomic, readonly) NSString *postID;
@property(nonatomic, readonly) NSString *title;


- (id)initWithUser:(MEUser *)aUser;
- (id)initWithPost:(MEPost *)aPost;


@end
