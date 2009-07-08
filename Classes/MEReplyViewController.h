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
@class MEImageButton;
@class MEPostBodyView;
@class MEMediaView;


@interface MEReplyViewController : UIViewController <UIActionSheetDelegate>
{
    IBOutlet UINavigationBar *mNaviBar;
    IBOutlet UIView          *mContainerView;
    IBOutlet MEImageButton   *mIconButton;
    IBOutlet MEPostBodyView  *mPostBodyView;
    IBOutlet UIScrollView    *mPostScrollView;
    IBOutlet UITableView     *mTableView;
    IBOutlet UIBarButtonItem *mActionButtonItem;

    NSString       *mPostID;
    MEPost         *mPost;
    NSMutableArray *mComments;
    MEUser         *mTappedUser;

    MEMediaView    *mMediaView;
}

- (id)initWithPost:(MEPost *)aPost;
- (id)initWithPostID:(NSString *)aPostID;

- (IBAction)actionButtonTapped:(id)aSender;
- (IBAction)closeButtonTapped:(id)aSender;
- (IBAction)iconButtonTapped:(id)aSender;

@end
