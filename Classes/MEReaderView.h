/*
 *  MEReaderView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MEPost.h"


@interface MEReaderView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    id                   mDelegate;
    NSMutableArray      *mPostArray;
    UITableView         *mTableView;
    NSMutableDictionary *mCellHeightDict;
}

- (void)setDelegate:(id)aDelegate;
- (void)setUser:(MEUser *)aUser;
- (void)setHiddenPostButton:(BOOL)aFlag;

- (void)addPost:(MEPost *)aPost;
- (void)addPosts:(NSArray *)aPostArray;
- (void)removeAllPosts;

@end


@protocol MEReaderView

- (void)newPostForReaderView:(MEReaderView *)aReaderView;

@end
