/*
 *  MEAttributedLayoutManager.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 24.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEAttributedLayoutManager.h"
#import "MEAttributedLabel.h"
#import "MEAttributedString.h"


@interface MEAttributedLayoutInfo : NSObject
{
    NSDictionary *mAttributes;
    NSRange       mTextRange;
    CGRect        mLabelFrame;
}

@property(nonatomic, retain) NSDictionary *attributes;
@property(nonatomic, assign) NSRange       textRange;
@property(nonatomic, assign) CGRect        labelFrame;

@end

@implementation MEAttributedLayoutInfo

@synthesize attributes = mAttributes;
@synthesize textRange  = mTextRange;
@synthesize labelFrame = mLabelFrame;


+ (id)layoutInfoWithAttributes:(NSDictionary *)aAttributes text:(NSString *)aText range:(NSRange *)aRange rect:(CGRect)aRect
{
    MEAttributedLayoutInfo *sLayoutInfo = nil;
    UIFont                 *sFont;
    CGSize                  sSize;
    NSRange                 sRange;

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

- (UILabel *)labelWithText:(NSString *)aText
{
    UILabel *sLabel;
    id       sValue;

    sLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];

    sValue = [mAttributes objectForKey:MEFontAttributeName];
    if (sValue)
    {
        [sLabel setFont:sValue];
    }

    sValue = [mAttributes objectForKey:MEForegroundColorAttributeName];
    if (sValue)
    {
        [sLabel setTextColor:sValue];
    }

    sValue = [mAttributes objectForKey:MEBackgroundColorAttributeName];
    if (sValue)
    {
        [sLabel setBackgroundColor:sValue];
    }

    sValue = [mAttributes objectForKey:MEHighlightedColorAttributeName];
    if (sValue)
    {
        [sLabel setHighlightedTextColor:sValue];
    }

    sValue = [mAttributes objectForKey:MEShadowColorAttributeName];
    if (sValue)
    {
        [sLabel setShadowColor:sValue];
    }

    sValue = [mAttributes objectForKey:MEShadowOffsetAttributeName];
    if (sValue)
    {
        [sLabel setShadowOffset:[sValue CGSizeValue]];
    }

    [sLabel setText:[aText substringWithRange:mTextRange]];
    [sLabel setFrame:mLabelFrame];

    return sLabel;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> %@ %@ %@", NSStringFromClass([self class]), self, mAttributes, NSStringFromRange(mTextRange), NSStringFromCGRect(mLabelFrame)];
}

@end


@implementation MEAttributedLayoutManager

@synthesize layoutSize  = mLayoutSize;
@synthesize layoutWidth = mLayoutWidth;


- (id)init
{
    self = [super init];

    if (self)
    {
        mLayoutInfos = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)dealloc
{
    [mLayoutInfos release];
    [super dealloc];
}

- (void)invalidate
{
    [mLayoutInfos removeAllObjects];
    mLayoutSize  = CGSizeZero;
    mLayoutWidth = 0;
}

- (void)layoutAttributedString:(MEAttributedString *)aString forWidth:(CGFloat)aWidth
{
    NSAutoreleasePool *sPool;
    NSString          *sText;
    NSUInteger         sLen;
    NSUInteger         sLoc;
    CGRect             sRect;
    CGFloat            sWidth;
    CGFloat            sHeight;

    if ((aWidth > 0) && (aWidth != mLayoutWidth))
    {
        [mLayoutInfos removeAllObjects];
        mLayoutSize  = CGSizeZero;
        mLayoutWidth = aWidth;

        sPool   = [[NSAutoreleasePool alloc] init];

        sText   = [aString string];
        sLen    = [aString length];
        sLoc    = 0;
        sRect   = CGRectMake(0, 0, aWidth, 0);
        sWidth  = 0;
        sHeight = 0;

        for (sLoc = 0; sLoc < sLen;)
        {
            NSDictionary           *sAttributes;
            NSString               *sLayoutText;
            MEAttributedLayoutInfo *sLayoutInfo;
            NSRange                 sRange;

            sAttributes = [aString attributesAtIndex:sLoc effectiveRange:&sRange];
            sRange      = NSMakeRange(sLoc, NSMaxRange(sRange) - sLoc);
            sLayoutText = [sText substringWithRange:sRange];
            sLayoutInfo = [MEAttributedLayoutInfo layoutInfoWithAttributes:sAttributes text:sLayoutText range:&sRange rect:sRect];

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
                if (mLayoutSize.width < sWidth)
                {
                    mLayoutSize.width = sWidth;
                }

                mLayoutSize.height += sHeight;
                sRect.origin.x       = 0;
                sRect.origin.y      += sHeight;
                sRect.size.width     = aWidth;
                sWidth               = 0;
                sHeight              = 0;
            }
        }

        if (mLayoutSize.width < sWidth)
        {
            mLayoutSize.width = sWidth;
        }

        mLayoutSize.height += sHeight;

        [sPool release];
    }
}

- (void)layoutOnAttributedLabel:(MEAttributedLabel *)aLabel
{
    UILabel                *sLabel;
    MEAttributedLayoutInfo *sLayoutInfo;
    NSString               *sText;
    CGRect                  sBounds;

    for (sLabel in [aLabel subviews])
    {
        [sLabel removeFromSuperview];
    }

    sText   = [[aLabel attributedText] string];
    sBounds = [aLabel bounds];

    for (sLayoutInfo in mLayoutInfos)
    {
        sLabel = [sLayoutInfo labelWithText:sText];

        if (CGRectContainsRect(sBounds, [sLabel frame]))
        {
            [aLabel addSubview:sLabel];
        }
    }
}

@end
