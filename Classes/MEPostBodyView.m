/*
 *  MEPostBodyView.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 30.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEPostBodyView.h"
#import "MEAttributedLabel.h"
#import "MEAttributedString.h"


#define kBodyWidth         250
#define kLabelSpacing      5
#define kBottomLabelHeight 13


@interface MEPostBodyView (Private)
@end

@implementation MEPostBodyView (Private)

+ (UIFont *)tagFont
{
    return [UIFont systemFontOfSize:10.0];
}

- (void)initSelf
{
    mBodyLabel = [[MEAttributedLabel alloc] initWithFrame:CGRectZero];
    [self addSubview:mBodyLabel];

    mTagsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [mTagsLabel setLineBreakMode:UILineBreakModeCharacterWrap];
    [mTagsLabel setNumberOfLines:0];
    [mTagsLabel setFont:[MEPostBodyView tagFont]];
    [mTagsLabel setTextColor:[UIColor grayColor]];
    [mTagsLabel setHighlightedTextColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
    [self addSubview:mTagsLabel];
    [mTagsLabel release];

    mTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [mTimeLabel setFont:[MEPostBodyView tagFont]];
    [mTimeLabel setTextColor:[UIColor grayColor]];
    [mTimeLabel setHighlightedTextColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
    [self addSubview:mTimeLabel];
    [mTimeLabel release];

    mCommentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [mCommentsLabel setFont:[MEPostBodyView tagFont]];
    [mCommentsLabel setTextColor:[UIColor grayColor]];
    [mCommentsLabel setTextAlignment:UITextAlignmentRight];
    [mCommentsLabel setHighlightedTextColor:[UIColor colorWithWhite:0.8 alpha:1.0]];
    [self addSubview:mCommentsLabel];
    [mCommentsLabel release];
}

@end


@implementation MEPostBodyView

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];

    if (self)
    {
        [self initSelf];
    }

    return self;
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        [self initSelf];
    }

    return self;
}

- (void)dealloc
{
    [super dealloc];
}


+ (CGFloat)heightWithBodyText:(MEAttributedString *)aBodyText tagsText:(NSString *)aTagsText
{
    CGFloat sHeight = 0;

    sHeight += [aBodyText sizeForWidth:kBodyWidth].height;
    sHeight += kLabelSpacing;
    sHeight += [aTagsText sizeWithFont:[MEPostBodyView tagFont] constrainedToSize:CGSizeMake(kBodyWidth, 1000) lineBreakMode:UILineBreakModeCharacterWrap].height;
    sHeight += kLabelSpacing;
    sHeight += kBottomLabelHeight;

    return sHeight;
}


- (void)setBodyText:(MEAttributedString *)aBodyText
{
    if (![[mBodyLabel attributedText] isEqual:aBodyText])
    {
        [mBodyLabel setAttributedText:aBodyText];
        [self setNeedsLayout];
    }
}

- (void)setTagsText:(NSString *)aTagsText
{
    if (![[mTagsLabel text] isEqualToString:aTagsText])
    {
        [mTagsLabel setText:aTagsText];
        [self setNeedsLayout];
    }
}

- (void)setTimeText:(NSString *)aTimeText
{
    [mTimeLabel setText:aTimeText];
}

- (void)setNumberOfComments:(NSInteger)aNumberOfComments
{
    [mCommentsLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Comments (%d)", @""), aNumberOfComments]];
}


- (void)layoutSubviews
{
    CGRect  sRect;
    CGFloat sOffset = 0;

    [mBodyLabel setFrame:CGRectMake(0, sOffset, kBodyWidth, 0)];
    [mBodyLabel sizeToFit];

    sOffset += [mBodyLabel frame].size.height + kLabelSpacing;

    [mTagsLabel setFrame:CGRectMake(0, sOffset, kBodyWidth, 0)];
    [mTagsLabel sizeToFit];

    sOffset += [mTagsLabel frame].size.height + kLabelSpacing;

    [mTimeLabel setFrame:CGRectMake(0, sOffset, 120, kBottomLabelHeight)];
    [mCommentsLabel setFrame:CGRectMake(130, sOffset, 120, kBottomLabelHeight)];

    sRect             = [self frame];
    sRect.size.height = sOffset + 13;

    [self setFrame:sRect];
}


@end
