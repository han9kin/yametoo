/*
 *  MECharCounter.h
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 11.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface MECharCounter : NSObject
{
    CALayer  *mLayer;
    NSInteger mLimitCount;
    id        mTextOwner;
}

- (id)initWithParentView:(UIView *)aView;

- (void)setLimitCount:(NSInteger)aLimitCount;
- (NSInteger)limitCount;
- (void)setTextOwner:(id)aTextOwner;
- (void)setHidden:(BOOL)aFlag;
- (void)setFrame:(CGRect)aFrame;
- (void)update;

@end
