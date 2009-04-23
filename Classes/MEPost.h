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

    NSURL      *mIconURL;           //  Thumbnail image of me2PhotoImage
    NSURL      *mKindIconImageURL;
    
    //  Media
    NSURL      *mMe2PhotoImageURL;

    UIImage    *mMe2PhotoImage;
    UIImage    *mKindIconImage;

    NSString   *mTagsStr;
    NSString   *mPubTimeStr;
    
//    NSString   *mPermaLink;
//    NSURL      *mMe2DayPageURL;
//    NSURL      *mCallbackURL;
//    NSString   *mContentType;
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
@property(nonatomic, readonly) NSURL     *me2PhotoImageURL;
@property(nonatomic, readonly) NSURL     *kindIconImageURL;
@property(nonatomic, readonly) NSURL     *iconURL;


- (id)initWithDictionary:(NSDictionary *)aPostDict;

- (NSString *)tagsString;
- (NSString *)pubTimeString;

@end
