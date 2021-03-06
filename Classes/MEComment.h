/*
 *  MEComment.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 28.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


#define kMECommentBodyMaxLen 150


@class MEAttributedString;
@class MEUser;

@interface MEComment : NSObject
{
    NSString           *mCommentID;
    MEAttributedString *mBody;
    NSDate             *mPubDate;
    MEUser             *mAuthor;
    NSMutableArray     *mLinks;
}

@property(nonatomic, readonly) NSString           *commentID;
@property(nonatomic, readonly) MEAttributedString *body;
@property(nonatomic, readonly) NSDate             *pubDate;
@property(nonatomic, readonly) MEUser             *author;
@property(nonatomic, readonly) NSArray            *links;


- (id)initWithDictionary:(NSDictionary *)aCommentDict;


@end
