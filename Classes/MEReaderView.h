/*
 *  MEReaderView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEPost;
@class MEUser;
@class MEMediaView;


@interface MEReaderView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    id                   mDelegate;

    MEUser              *mUser;

    NSMutableArray      *mPostArray;
    UITableView         *mTableView;
    NSMutableDictionary *mCellHeightDict;
    BOOL                 mShowsPostAuthor;

    MEMediaView         *mMediaView;
}

- (void)setDelegate:(id)aDelegate;
- (void)setUser:(MEUser *)aUser;
- (void)setHiddenPostButton:(BOOL)aFlag;
- (void)setShowsPostAuthor:(BOOL)aFlag;

- (void)addPost:(MEPost *)aPost;
- (void)addPosts:(NSArray *)aPostArray;
- (void)removeAllPosts;

@end


@protocol MEReaderViewDelegate

- (void)newPostForReaderView:(MEReaderView *)aReaderView;

@end
