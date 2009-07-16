/*
 *  MEReadViewController.h
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


@interface MEReadViewController : UIViewController <UIActionSheetDelegate>
{
    UIView         *mHeaderView;
    MEImageButton  *mIconButton;
    MEPostBodyView *mPostBodyView;
    UITableView    *mTableView;

    NSString       *mPostID;
    MEPost         *mPost;
    NSMutableArray *mComments;
}

@property(nonatomic, assign) IBOutlet UIView         *headerView;
@property(nonatomic, assign) IBOutlet MEImageButton  *iconButton;
@property(nonatomic, assign) IBOutlet MEPostBodyView *postBodyView;
@property(nonatomic, assign) IBOutlet UITableView    *tableView;


- (id)initWithPost:(MEPost *)aPost;
- (id)initWithPostID:(NSString *)aPostID;

- (IBAction)metoo;
- (IBAction)reply;

@end
