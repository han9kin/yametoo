/*
 *  MEListViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


typedef enum MEListViewControllerType
{
    kMEListViewControllerTypeMyMetoo,
    kMEListViewControllerTypeMyFriends,
} MEListViewControllerType;


@class    MEMediaView;
@class    MEListView;
@class    MEUser;
@protocol MEListViewDataSource;
@protocol MEListViewDelegate;


@interface MEListViewController : UIViewController <MEListViewDataSource, MEListViewDelegate, UIActionSheetDelegate>
{
    UILabel        *mTitleLabel;
    MEListView   *mListView;
    MEMediaView    *mMediaView;

    NSString       *mTitle;
    NSString       *mTitleUserID;
    NSMutableArray *mPosts;
    NSDate         *mLastestDate;
    NSTimer        *mTimer;
    MEUser         *mTappedUser;

    NSInteger       mMoreOffset;
    NSInteger       mUpdateOffset;
}


- (void)setTitleUserID:(NSString *)aUserID;

- (void)invalidateData;
- (void)reloadData;


#pragma mark subclass responsibles

- (void)configureListView:(MEListView *)aListView;
- (void)fetchFromOffset:(NSInteger)aOffset count:(NSInteger)aCount;


@end
