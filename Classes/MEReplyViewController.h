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

    MECharCounter *mCharCounter;
    MEPost        *mPost;
}

@property(nonatomic, assign) IBOutlet UITextView *textView;


- (id)initWithPost:(MEPost *)aPost;


@end
