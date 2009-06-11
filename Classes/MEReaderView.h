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
@class MEReaderView;


@protocol MEReaderViewDataSource <NSObject>

@optional

- (MEUser *)authorOfPostsInReaderView:(MEReaderView *)aReaderView;

@required

- (NSInteger)numberOfSectionsInReaderView:(MEReaderView *)aReaderView;
- (NSString *)readerView:(MEReaderView *)aReaderView titleForSection:(NSInteger)aSection;
- (NSInteger)readerView:(MEReaderView *)aReaderView numberOfPostsInSection:(NSInteger)aSection;
- (MEPost *)readerView:(MEReaderView *)aReaderView postAtIndexPath:(NSIndexPath *)aIndexPath;

@end

@protocol MEReaderViewDelegate <NSObject>

@optional

- (void)readerViewDidTapNewPostButton:(MEReaderView *)aReaderView;
- (void)readerViewDidTapFetchMoreButton:(MEReaderView *)aReaderView;
- (void)readerView:(MEReaderView *)aReaderView didTapUserInfoButtonForUser:(MEUser *)aUser;
- (void)readerView:(MEReaderView *)aReaderView didTapPostIconButtonForPost:(MEPost *)aPost;
- (void)readerView:(MEReaderView *)aReaderView didSelectPostAtIndexPath:(NSIndexPath *)aIndexPath;

@end



@interface MEReaderView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    id<MEReaderViewDataSource>  mDataSource;
    id<MEReaderViewDelegate>    mDelegate;

    UITableView                *mTableView;

    NSMutableArray             *mSectionTitleCache;
    NSMutableDictionary        *mCellHeightCache;
    NSInteger                   mSectionCount;

    BOOL                        mShowsPostAuthor;
    BOOL                        mShowsPostButton;
}

@property(nonatomic, assign) id<MEReaderViewDataSource> dataSource;
@property(nonatomic, assign) id<MEReaderViewDelegate>   delegate;


- (void)setTitleUserID:(NSString *)aUserID;
- (void)setShowsPostAuthor:(BOOL)aShowsPostAuthor;
- (void)setShowsPostButton:(BOOL)aShowsPostButton;

- (NSIndexPath *)indexPathForSelectedPost;
- (void)selectPostAtIndexPath:(NSIndexPath *)aIndexPath animated:(BOOL)aAnimated scrollPosition:(UITableViewScrollPosition)aScrollPosition;
- (void)deselectPostAtIndexPath:(NSIndexPath *)aIndexPath animated:(BOOL)aAnimated;

- (void)invalidateData;
- (void)reloadData;


@end
