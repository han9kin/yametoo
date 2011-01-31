/*
 *  MEReplyViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 04.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEReplyViewController : UIViewController
{
    UINavigationBar *mNavigationBar;
    UITextView      *mTextView;
    UILabel         *mCounterLabel;

    NSString        *mPostID;
    NSString        *mText;
}

@property(nonatomic, assign) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic, assign) IBOutlet UITextView      *textView;
@property(nonatomic, assign) IBOutlet UILabel         *counterLabel;


- (id)initWithPostID:(NSString *)aPostID;
- (id)initWithPostID:(NSString *)aPostID callUserID:(NSString *)aUserID;


- (IBAction)close;
- (IBAction)upload;


@end
