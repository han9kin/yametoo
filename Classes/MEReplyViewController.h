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


@interface MEReplyViewController : UIViewController
{
    IBOutlet MEImageView    *mIconView;
    IBOutlet MEPostBodyView *mPostBodyView;
    IBOutlet UIScrollView   *mPostScrollView;
    IBOutlet UITableView    *mTableView;
    
    MEPost         *mPost;
    NSMutableArray *mComments;
}

@property (nonatomic, retain) MEPost *post;

- (IBAction)closeButtonTapped:(id)aSender;

@end
