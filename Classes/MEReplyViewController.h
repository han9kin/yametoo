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

    MEPost         *mPost;
    NSMutableArray *mComments;

    NSInteger       mAddCommentIndex;
    NSInteger       mAddMetooIndex;
    NSInteger       mCancelIndex;
}

- (id)initWithPost:(MEPost *)aPost;

- (IBAction)actionButtonTapped:(id)aSender;
- (IBAction)closeButtonTapped:(id)aSender;


@end
