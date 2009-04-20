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

@property(nonatomic, copy)   NSString *postID;
@property(nonatomic, copy)   NSString *body;
@property(nonatomic, copy)   NSString *kind;
@property(nonatomic, copy)   NSDate   *pubDate;
@property(nonatomic)         NSInteger commentsCount;
@property(nonatomic)         NSInteger metooCount;
@property(nonatomic, retain) MEUser   *user;
@property(nonatomic, retain) NSArray  *tags;
@property(nonatomic, retain) UIImage  *me2PhotoImage;
@property(nonatomic, retain) UIImage  *kindIconImage;

@end
