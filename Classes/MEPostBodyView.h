/*
 *  MEPostBodyView.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 30.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEAttributedLabel;
@class MEAttributedString;

@interface MEPostBodyView : UIView
{
    MEAttributedLabel *mBodyLabel;
    UILabel           *mTagsLabel;
    UILabel           *mTimeLabel;
    UILabel           *mCommentsLabel;
}

+ (CGFloat)heightWithBodyText:(MEAttributedString *)aBodyText tagsText:(NSString *)aTagsText;

- (void)setBodyText:(MEAttributedString *)aBodyText;
- (void)setTagsText:(NSString *)aTagsText;
- (void)setTimeText:(NSString *)aTimeText;
- (void)setNumberOfComments:(NSInteger)aNumberOfComments;

@end
