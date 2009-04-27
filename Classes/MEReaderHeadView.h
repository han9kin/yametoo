/*
 *  MEReaderHeadView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


#define kReaderHeadViewHeight       70
#define kFaceImageViewWidth         50
#define kFaceImageViewHeight        50
#define kNickButtonWidth            152
#define kNickButtonHeight           35
#define kPostButtonWidth            90
#define kPostButtonHeight           35


@class MEImageView;

@interface MEReaderHeadView : UIView
{
    id           mDelegate;
    MEImageView *mFaceImageView;
    UIButton    *mNicknameButton;
    UIButton    *mNewPostButton;
}

+ (MEReaderHeadView *)readerHeadView;

- (void)setDelegate:(id)aDelegate;
- (void)setNickname:(NSString *)aNickname;
- (void)setFaceImageURL:(NSURL *)aFaceImageURL;
- (void)setHiddenPostButton:(BOOL)aFlag;

- (IBAction)nicknameButtonTapped:(id)aSender;
- (IBAction)newPostButtonTapped:(id)aSender;

@end


@protocol MEReaderHeadViewDelegate

- (void)newPostButtonTapped:(MEReaderHeadView *)aHeaderView;

@end
