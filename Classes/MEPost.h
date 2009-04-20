/*
 *  MEPost.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "MEUser.h"


@interface MEPost : NSObject
{
    NSString   *mPostID;
    NSString   *mBody;
    NSString   *mKind;
    NSDate     *mPubDate;
    NSInteger   mCommentsCount;
    NSInteger   mMetooCount;
    MEUser     *mUser;
    NSArray    *mTagArray;

    NSString   *mMe2PhotoImageURLStr;
    NSString   *mKindIconImageURLStr;

    UIImage    *mMe2PhotoImage;
    UIImage    *mKindIconImage;

//    NSString   *mPermaLink;
//    NSURL      *mMe2DayPageURL;
//    NSURL      *mCallbackURL;
//    NSString   *mContentType;
//    NSURL      *mIconURL;
}

@property(nonatomic, readonly) NSString  *postID;
@property(nonatomic, readonly) NSString  *body;
@property(nonatomic, readonly) NSString  *kind;
@property(nonatomic, readonly) NSDate    *pubDate;
@property(nonatomic, readonly) NSInteger  commentsCount;
@property(nonatomic, readonly) NSInteger  metooCount;
@property(nonatomic, readonly) MEUser    *user;
@property(nonatomic, readonly) NSArray   *tags;
@property(nonatomic, readonly) UIImage   *me2PhotoImage;
@property(nonatomic, readonly) UIImage   *kindIconImage;


- (id)initWithDictionary:(NSDictionary *)aPostDict;


@end
