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
- (void)readerView:(MEReaderView *)aReaderView didTapUserInfoButtonForUser:(MEUser *)aUser;
- (void)readerView:(MEReaderView *)aReaderView didTapPostIconButtonForPost:(MEPost *)aPost;
- (void)readerView:(MEReaderView *)aReaderView didSelectPostAtIndexPath:(NSIndexPath *)aIndexPath;

@end



@interface MEReaderView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    id<MEReaderViewDataSource>  mDataSource;
    id<MEReaderViewDelegate>    mDelegate;

    UITableView                *mTableView;
    NSMutableDictionary        *mCellHeightDict;
    BOOL                        mShowsPostAuthor;
}

@property(nonatomic, assign) id<MEReaderViewDataSource> dataSource;
@property(nonatomic, assign) id<MEReaderViewDelegate>   delegate;


- (void)setHiddenPostButton:(BOOL)aFlag;
- (void)setShowsPostAuthor:(BOOL)aFlag;

- (NSIndexPath *)indexPathForSelectedPost;
- (void)selectPostAtIndexPath:(NSIndexPath *)aIndexPath animated:(BOOL)aAnimated scrollPosition:(UITableViewScrollPosition)aScrollPosition;
- (void)deselectPostAtIndexPath:(NSIndexPath *)aIndexPath animated:(BOOL)aAnimated;

- (void)reloadData;


@end
