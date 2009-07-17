/*
 *  MEReplyViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 04.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEPost;
@class MECharCounter;


@interface MEReplyViewController : UIViewController
{
    UITextView    *mTextView;
    UILabel       *mCounterLabel;

    MEPost        *mPost;
}

@property(nonatomic, assign) IBOutlet UITextView *textView;
@property(nonatomic, assign) IBOutlet UILabel    *counterLabel;


- (id)initWithPost:(MEPost *)aPost;


- (IBAction)close;
- (IBAction)upload;


@end
