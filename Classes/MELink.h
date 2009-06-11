/*
 *  MELink.h
 *  yametoo
 *
 *  Created by han9kin on 09. 06. 04.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


typedef enum MELinkType
{
    kMELinkTypeUnknown = 0,
    kMELinkTypeMe2DAY,
    kMELinkTypePost,
    kMELinkTypeOther
} MELinkType;


@class    MEUser;
@protocol MEClientDelegate;

@interface MELink : NSObject <MEClientDelegate>
{
    id          mURL;
    NSString   *mTitle;
    NSString   *mDescription;
    MELinkType  mType;
}

@property(nonatomic, readonly) id          url;
@property(nonatomic, readonly) NSString   *title;
@property(nonatomic, readonly) NSString   *urlDescription;
@property(nonatomic, readonly) MELinkType  type;


- (id)initWithURL:(id)aURL title:(NSString *)aTitle;
- (id)initWithUser:(MEUser *)aUser;

- (void)appendTitle:(NSString *)aTitle;


@end
