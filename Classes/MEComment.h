/*
 *  MEComment.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@class MEAttributedString;
@class MEUser;

@interface MEComment : NSObject
{
    NSString           *mCommentID;
    MEAttributedString *mBody;
    NSDate             *mPubDate;
    MEUser             *mAuthor;
}

@property(nonatomic, readonly) NSString           *commentID;
@property(nonatomic, readonly) MEAttributedString *body;
@property(nonatomic, readonly) NSDate             *pubDate;
@property(nonatomic, readonly) MEUser             *author;


- (id)initWithDictionary:(NSDictionary *)aCommentDict;


@end
