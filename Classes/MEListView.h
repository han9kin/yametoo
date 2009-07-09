/*
 *  MEListView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEPost;
@class MEUser;
@class MEListView;


@protocol MEListViewDataSource <NSObject>

@optional

- (MEUser *)authorOfPostsInListView:(MEListView *)aListView;

@required

- (NSInteger)numberOfSectionsInListView:(MEListView *)aListView;
- (NSString *)listView:(MEListView *)aListView titleForSection:(NSInteger)aSection;
- (NSInteger)listView:(MEListView *)aListView numberOfPostsInSection:(NSInteger)aSection;
- (MEPost *)listView:(MEListView *)aListView postAtIndexPath:(NSIndexPath *)aIndexPath;

@end

@protocol MEListViewDelegate <NSObject>

@optional

- (void)listViewDidTapNewPostButton:(MEListView *)aListView;
- (void)listViewDidTapFetchMoreButton:(MEListView *)aListView;
- (void)listView:(MEListView *)aListView didTapUserInfoButtonForUser:(MEUser *)aUser;
- (void)listView:(MEListView *)aListView didTapPostIconButtonForPost:(MEPost *)aPost;
- (void)listView:(MEListView *)aListView didSelectPostAtIndexPath:(NSIndexPath *)aIndexPath;

@end



@interface MEListView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    id<MEListViewDataSource>  mDataSource;
    id<MEListViewDelegate>    mDelegate;

    UITableView                *mTableView;

    NSMutableArray             *mSectionTitleCache;
    NSMutableDictionary        *mCellHeightCache;
    NSInteger                   mSectionCount;

    BOOL                        mShowsPostAuthor;
    BOOL                        mShowsPostButton;
}

@property(nonatomic, assign) id<MEListViewDataSource> dataSource;
@property(nonatomic, assign) id<MEListViewDelegate>   delegate;


- (void)setTitleUserID:(NSString *)aUserID;
- (void)setShowsPostAuthor:(BOOL)aShowsPostAuthor;
- (void)setShowsPostButton:(BOOL)aShowsPostButton;

- (NSIndexPath *)indexPathForSelectedPost;
- (void)selectPostAtIndexPath:(NSIndexPath *)aIndexPath animated:(BOOL)aAnimated scrollPosition:(UITableViewScrollPosition)aScrollPosition;
- (void)deselectPostAtIndexPath:(NSIndexPath *)aIndexPath animated:(BOOL)aAnimated;

- (void)invalidateData;
- (void)reloadData;


@end
