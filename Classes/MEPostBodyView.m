/*
 *  MEPostBodyView.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 30.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEPostBodyView.h"
#import "MEPost.h"
#import "MEAttributedLabel.h"
#import "MEAttributedString.h"


#define kDefaultBodyWidth  250
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

    mBodyWidth = [self frame].size.width;

    if (mBodyWidth == 0)
    {
        mBodyWidth = kDefaultBodyWidth;
    }
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


+ (CGFloat)heightWithPost:(MEPost *)aPost
{
    CGFloat sHeight = 0;

    sHeight += [[aPost body] sizeForWidth:kDefaultBodyWidth].height;
    sHeight += kLabelSpacing;
    sHeight += [[aPost tagsString] sizeWithFont:[MEPostBodyView tagFont] constrainedToSize:CGSizeMake(kDefaultBodyWidth, 1000) lineBreakMode:UILineBreakModeCharacterWrap].height;
    sHeight += kLabelSpacing;
    sHeight += kBottomLabelHeight;

    return sHeight;
}


- (void)setPost:(MEPost *)aPost
{
    [mBodyLabel setAttributedText:[aPost body]];
    [mTagsLabel setText:[aPost tagsString]];
    [mTimeLabel setText:[aPost pubTimeString]];
    [mCommentsLabel setText:[NSString stringWithFormat:NSLocalizedString(@"Comments (%d)", @""), [aPost commentsCount]]];

    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    CGRect  sRect;
    CGFloat sOffset = 0;

    [mBodyLabel setFrame:CGRectMake(0, sOffset, mBodyWidth, 0)];
    [mBodyLabel sizeToFit];

    sOffset += [mBodyLabel frame].size.height + kLabelSpacing;

    [mTagsLabel setFrame:CGRectMake(0, sOffset, mBodyWidth, 0)];
    [mTagsLabel sizeToFit];

    sOffset += [mTagsLabel frame].size.height + kLabelSpacing;

    [mTimeLabel setFrame:CGRectMake(0, sOffset, 120, kBottomLabelHeight)];
    [mCommentsLabel setFrame:CGRectMake(130, sOffset, 120, kBottomLabelHeight)];

    sRect             = [self frame];
    sRect.size.height = sOffset + 13;

    [self setFrame:sRect];
}


@end
