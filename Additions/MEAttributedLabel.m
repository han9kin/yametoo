/*
 *  MEAttributedLabel.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 21.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEAttributedLabel.h"
#import "MEAttributedString.h"


@interface MEALLayoutInfo : NSObject
{
    NSDictionary *mAttributes;
    NSRange       mTextRange;
    CGRect        mLabelFrame;
}

@property(nonatomic, retain) NSDictionary *attributes;
@property(nonatomic, assign) NSRange       textRange;
@property(nonatomic, assign) CGRect        labelFrame;

@end

@implementation MEALLayoutInfo

@synthesize attributes = mAttributes;
@synthesize textRange  = mTextRange;
@synthesize labelFrame = mLabelFrame;


+ (id)layoutInfoWithAttributes:(NSDictionary *)aAttributes text:(NSString *)aText range:(NSRange *)aRange rect:(CGRect)aRect
{
    MEALLayoutInfo *sLayoutInfo = nil;
    UIFont         *sFont;
    CGSize          sSize;
    NSRange         sRange;

    sFont = [aAttributes objectForKey:MEFontAttributeName];

    if (!sFont)
    {
        sFont = [UIFont systemFontOfSize:17.0];
    }

    sRange = [aText lineRangeForRange:NSMakeRange(0, 1)];
    sSize  = [[aText substringWithRange:sRange] sizeWithFont:sFont];

    if (sSize.width > aRect.size.width)
    {
        CGFloat    sWidth;
        NSUInteger sIndex;

        sSize.width = 0;

        for (sIndex = 0; sIndex < sRange.length; sIndex++)
        {
            sWidth = [[aText substringWithRange:NSMakeRange(sIndex, 1)] sizeWithFont:sFont].width;

            if ((sSize.width + sWidth) > aRect.size.width)
            {
                break;
            }
            else
            {
                sSize.width += sWidth;
            }
        }

        sRange.length = sIndex;

        if (sSize.width > 0)
        {
            sLayoutInfo = [[[self alloc] init] autorelease];
        }
    }
    else
    {
        sLayoutInfo = [[[self alloc] init] autorelease];
    }

    aRange->length = sRange.length;

    [sLayoutInfo setAttributes:aAttributes];
    [sLayoutInfo setTextRange:*aRange];
    [sLayoutInfo setLabelFrame:CGRectMake(aRect.origin.x, aRect.origin.y, sSize.width, sSize.height)];

    return sLayoutInfo;
}

@end


@interface MEAttributedLabel (Private)
@end

@implementation MEAttributedLabel (Private)


#pragma mark building layout info

- (void)clearLayoutInfo
{
    [mLayoutInfos removeAllObjects];
}

- (void)buildLayoutInfo
{
    NSAutoreleasePool *sPool;
    NSString          *sText;
    NSUInteger         sLen;
    NSUInteger         sLoc;
    CGRect             sRect;
    CGFloat            sBoundsWidth;
    CGFloat            sWidth;
    CGFloat            sHeight;

    [mLayoutInfos removeAllObjects];
    mContentSize = CGSizeZero;

    sPool   = [[NSAutoreleasePool alloc] init];

    sText   = [mText string];
    sLen    = [mText length];
    sLoc    = 0;
    sRect   = [self bounds];
    sBoundsWidth = sRect.size.width;
    sWidth  = 0;
    sHeight = 0;

    for (sLoc = 0; sLoc < sLen;)
    {
        NSDictionary   *sAttributes;
        NSString       *sLayoutText;
        MEALLayoutInfo *sLayoutInfo;
        NSRange         sRange;

        sAttributes = [mText attributesAtIndex:sLoc effectiveRange:&sRange];
        sRange      = NSMakeRange(sLoc, NSMaxRange(sRange) - sLoc);
        sLayoutText = [sText substringWithRange:sRange];
        sLayoutInfo = [MEALLayoutInfo layoutInfoWithAttributes:sAttributes text:sLayoutText range:&sRange rect:sRect];

        if (sLayoutInfo)
        {
            CGSize sSize = [sLayoutInfo labelFrame].size;

            if (sHeight < sSize.height)
            {
                sHeight = sSize.height;
            }

            sRect.origin.x   += sSize.width;
            sRect.size.width -= sSize.width;
            sWidth           += sSize.width;
            sLoc             += sRange.length;

            [mLayoutInfos addObject:sLayoutInfo];
        }
        else
        {
            if (mContentSize.width < sWidth)
            {
                mContentSize.width = sWidth;
            }

            mContentSize.height += sHeight;
            sRect.origin.x       = 0;
            sRect.origin.y      += sHeight;
            sRect.size.width     = sBoundsWidth;
            sWidth               = 0;
            sHeight              = 0;
        }
    }

    if (mContentSize.width < sRect.size.width)
    {
        mContentSize.width = sRect.size.width;
    }

    mContentSize.height += sHeight;

    [sPool release];
}

- (void)buildLayoutInfoIfNeeded
{
    if (![mLayoutInfos count])
    {
        [self buildLayoutInfo];
    }
}


#pragma mark laying out labels

- (UILabel *)labelWithLayoutInfo:(MEALLayoutInfo *)aLayoutInfo text:(NSString *)aText
{
    UILabel      *sLabel;
    NSDictionary *sAttributes;
    id            sValue;

    sLabel      = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    sAttributes = [aLayoutInfo attributes];

    sValue = [sAttributes objectForKey:MEFontAttributeName];
    if (sValue)
    {
        [sLabel setFont:sValue];
    }

    sValue = [sAttributes objectForKey:MEForegroundColorAttributeName];
    if (sValue)
    {
        [sLabel setTextColor:sValue];
    }

    sValue = [sAttributes objectForKey:MEBackgroundColorAttributeName];
    if (sValue)
    {
        [sLabel setBackgroundColor:sValue];
    }

    sValue = [sAttributes objectForKey:MEHighlightedColorAttributeName];
    if (sValue)
    {
        [sLabel setHighlightedTextColor:sValue];
    }

    sValue = [sAttributes objectForKey:MEShadowColorAttributeName];
    if (sValue)
    {
        [sLabel setShadowColor:sValue];
    }

    sValue = [sAttributes objectForKey:MEShadowOffsetAttributeName];
    if (sValue)
    {
        [sLabel setShadowOffset:[sValue CGSizeValue]];
    }

    [sLabel setText:[aText substringWithRange:[aLayoutInfo textRange]]];
    [sLabel setFrame:[aLayoutInfo labelFrame]];

    return sLabel;
}

- (void)layoutLabels
{
    UILabel        *sLabel;
    MEALLayoutInfo *sLayoutInfo;
    NSString       *sText;
    CGRect          sBounds;

    for (sLabel in [self subviews])
    {
        [sLabel removeFromSuperview];
    }

    sText   = [mText string];
    sBounds = [self bounds];

    for (sLayoutInfo in mLayoutInfos)
    {
        sLabel = [self labelWithLayoutInfo:sLayoutInfo text:sText];

        if (CGRectContainsRect(sBounds, [sLabel frame]))
        {
            [self addSubview:sLabel];
        }
    }
}

@end


@implementation MEAttributedLabel

@dynamic attributedText;


- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        mLayoutInfos = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)dealloc
{
    [mText release];
    [mLayoutInfos release];
    [super dealloc];
}

- (CGSize)sizeThatFits:(CGSize)aSize
{
    [self buildLayoutInfoIfNeeded];

    return mContentSize;
}

- (void)setNeedsLayout
{
    [self clearLayoutInfo];
    [super setNeedsLayout];
}

- (void)layoutSubviews
{
    [self buildLayoutInfoIfNeeded];
    [self layoutLabels];
}


- (MEAttributedString *)attributedText
{
    return mText;
}

- (void)setAttributedText:(MEAttributedString *)aText
{
    if (![mText isEqual:aText])
    {
        [mText release];
        mText = [aText copy];

        [self setNeedsLayout];
    }
}

@end
