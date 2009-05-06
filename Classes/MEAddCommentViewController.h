/*
 *  MEAddCommentViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEPost;


@interface MEAddCommentViewController : UIViewController
{
    IBOutlet UITextView *mTextView;
    
    MEPost *mPost;
}

@property (nonatomic, retain) MEPost *post;

- (IBAction)closeButtonTapped:(id)aSender;
- (IBAction)postButtonTapped:(id)aSender;

@end