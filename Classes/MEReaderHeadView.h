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
#define kNickButtonWidth            142
#define kNickButtonHeight           35
#define kPostButtonWidth            90
#define kPostButtonHeight           35


@interface MEReaderHeadView : UIView
{
    UIImageView *mFaceImageView;
    UIButton    *mNicknameButton;
    UIButton    *mNewPostButton;
}

+ (MEReaderHeadView *)readerHeadView;

- (void)setNickname:(NSString *)aNickname;

- (IBAction)nicknameButtonTapped:(id)aSender;
- (IBAction)newPostButtonTapped:(id)aSender;

@end
