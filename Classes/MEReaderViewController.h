/*
 *  MEReaderViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MEReaderView.h"
#import "MEClient.h"


typedef enum MEReaderViewControllerType
{
    kMEReaderViewControllerTypeMyMetoo,
    kMEReaderViewControllerTypeMyFriends,
} MEReaderViewControllerType;


@class MEMediaView;


@interface MEReaderViewController : UIViewController <MEReaderViewDataSource, MEReaderViewDelegate>
{
    UILabel        *mTitleLabel;
    MEReaderView   *mReaderView;
    MEMediaView    *mMediaView;

    NSString       *mTitle;
    NSMutableArray *mPosts;
    NSDate         *mLastestDate;
    NSTimer        *mTimer;

    NSInteger       mMoreOffset;
    NSInteger       mUpdateOffset;
}


- (void)invalidateData;
- (void)reloadData;


#pragma mark subclass responsibles

- (void)configureReaderView:(MEReaderView *)aReaderView;
- (void)fetchFromOffset:(NSInteger)aOffset count:(NSInteger)aCount;


@end
