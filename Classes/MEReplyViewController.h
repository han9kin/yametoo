/*
 *  MEReplyViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 30.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEPost;
@class MEUser;
@class MEImageView;
@class MEPostBodyView;


@interface MEReplyViewController : UIViewController <UIActionSheetDelegate>
{
    IBOutlet UINavigationBar *mNaviBar;
    IBOutlet UIView          *mContainerView;
    IBOutlet MEImageView     *mIconView;
    IBOutlet MEPostBodyView  *mPostBodyView;
    IBOutlet UIScrollView    *mPostScrollView;
    IBOutlet UITableView     *mTableView;
    IBOutlet UIBarButtonItem *mActionButtonItem;

    NSString       *mPostID;
    MEPost         *mPost;
    NSMutableArray *mComments;
    MEUser         *mTappedUser;
}

- (id)initWithPost:(MEPost *)aPost;
- (id)initWithPostID:(NSString *)aPostID;

- (IBAction)actionButtonTapped:(id)aSender;
- (IBAction)closeButtonTapped:(id)aSender;


@end
