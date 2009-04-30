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


@interface MEReplyViewController : UIViewController
{
    IBOutlet UITableView *mTableView;
    
    MEPost         *mPost;
    NSMutableArray *mComments;
}

@property (nonatomic, retain) MEPost *post;

- (IBAction)closeButtonTapped:(id)aSender;

@end
