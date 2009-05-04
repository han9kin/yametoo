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


typedef enum MEReaderViewControllerType
{
    kMEReaderViewControllerTypeMyMetoo,
    kMEReaderViewControllerTypeMyFriends,
} MEReaderViewControllerType;


@class MEMediaView;

@interface MEReaderViewController : UIViewController <MEReaderViewDataSource, MEReaderViewDelegate>
{
    UILabel                    *mTitleLabel;
    MEReaderView               *mReaderView;
    MEMediaView                *mMediaView;

    MEUser                     *mUser;
    NSMutableArray             *mPostArray;

    MEReaderViewControllerType  mType;
}

@property(nonatomic, assign) MEReaderViewControllerType type;


@end
