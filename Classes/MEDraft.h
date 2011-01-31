/*
 *  MEDraft.h
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 24.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MEDraft : NSObject
{
    NSString  *mUserID;
    NSString  *mBody;
    NSString  *mTags;
    NSInteger  mIcon;
    UIImage   *mOriginalImage;
    UIImage   *mEditedImage;
}

@property(nonatomic, readonly) NSString  *userID;
@property(nonatomic, copy)     NSString  *body;
@property(nonatomic, copy)     NSString  *tags;
@property(nonatomic, assign)   NSInteger  icon;
@property(nonatomic, retain)   UIImage   *originalImage;
@property(nonatomic, retain)   UIImage   *editedImage;


+ (MEDraft *)lastDraftWithUserID:(NSString *)aUserID;
+ (void)clearLastDraftWithUserID:(NSString *)aUserID;

- (id)initWithUserID:(NSString *)aUserID;
- (void)save;

@end
