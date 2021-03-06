/*
 *  MEListViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 04.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MEClient.h"
#import "MEListView.h"


@class MEUser;

@interface MEListViewController : UIViewController <MEListViewDataSource, MEListViewDelegate, UIActionSheetDelegate>
{
    UIBarButtonItem       *mReloadButton;

    UILabel               *mMessageLabel;
    MEListView            *mListView;
    NSIndexPath           *mIndexPath;

    NSString              *mUserID;
    MEUser                *mUser;
    MEClientGetPostsScope  mScope;

    NSMutableArray        *mPosts;
    NSDate                *mLastestDate;
    NSTimer               *mTimer;

    NSInteger              mMoreOffset;
    NSInteger              mUpdateOffset;
}

@property(nonatomic, assign) IBOutlet MEListView *listView;


- (id)initWithUserID:(NSString *)aUserID scope:(MEClientGetPostsScope)aScope;
- (id)initWithUser:(MEUser *)aUser scope:(MEClientGetPostsScope)aScope;


@end
