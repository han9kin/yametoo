/*
 *  MEActionPopupViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


#define kActionPopupViewShowRepliesButton   0
#define kActionPopupViewPostReplyButton     1
#define kActionPopupViewShowPhotoButton     2
#define kActionPopupViewCancelButton        3


@interface MEActionPopupViewController : UIViewController
{
    id        mDelegate;
    NSString *mPostID;
    
    IBOutlet UIButton *mShowRepliesButton;
    IBOutlet UIButton *mPostReplyButton;
    IBOutlet UIButton *mShowPhotoButton;
    IBOutlet UIButton *mCancelButton;
}

@property (nonatomic, retain) NSString *postID;

- (void)setDelegate:(id)aDelegate;
- (void)setShowPhotoButtonEnabled:(BOOL)aFlag;
- (void)setShowRepliesButtonEnabled:(BOOL)aFlag;

- (IBAction)showRepliesButtonTapped:(id)aSender;
- (IBAction)postReplyButtonTapped:(id)aSender;
- (IBAction)showPhotoButtonTapped:(id)aSender;
- (IBAction)cancelButtonTapped:(id)aSender;

@end


@protocol MEActionPopupViewController

- (void)actionPopupViewController:(MEActionPopupViewController *)aActionPopupViewController
                     buttonTapped:(NSInteger)aButtonIndex;

@end