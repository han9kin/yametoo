/*
 *  MEReaderViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


typedef enum MEReaderViewControllerType
{
    kMEReaderViewControllerTypeMyMetoo,
    kMEReaderViewControllerTypeMyFriends,
} MEReaderViewControllerType;


@class    MEMediaView;
@class    MEReaderView;
@class    MEUser;
@protocol MEReaderViewDataSource;
@protocol MEReaderViewDelegate;


@interface MEReaderViewController : UIViewController <MEReaderViewDataSource, MEReaderViewDelegate, UIActionSheetDelegate>
{
    UILabel        *mTitleLabel;
    MEReaderView   *mReaderView;
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

- (void)configureReaderView:(MEReaderView *)aReaderView;
- (void)fetchFromOffset:(NSInteger)aOffset count:(NSInteger)aCount;


@end
