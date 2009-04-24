/*
 *  MEPost.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@class MEAttributedString;
@class MEUser;

@interface MEPost : NSObject
{
    NSString           *mPostID;
    MEAttributedString *mBody;
    NSString           *mKind;
    NSDate             *mPubDate;
    NSInteger           mCommentsCount;
    NSInteger           mMetooCount;
    MEUser             *mUser;
    NSArray            *mTags;
    NSURL              *mIconURL;
    NSURL              *mPhotoURL;
}

@property(nonatomic, readonly) NSString           *postID;
@property(nonatomic, readonly) MEAttributedString *body;
@property(nonatomic, readonly) NSString           *kind;
@property(nonatomic, readonly) NSDate             *pubDate;
@property(nonatomic, readonly) NSInteger           commentsCount;
@property(nonatomic, readonly) NSInteger           metooCount;
@property(nonatomic, readonly) MEUser             *user;
@property(nonatomic, readonly) NSArray            *tags;
@property(nonatomic, readonly) NSURL              *iconURL;
@property(nonatomic, readonly) NSURL              *photoURL;
@property(nonatomic, readonly) NSString           *tagsString;
@property(nonatomic, readonly) NSString           *pubTimeString;


- (id)initWithDictionary:(NSDictionary *)aPostDict;


@end
