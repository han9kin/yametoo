/*
 *  MEAttributedLayoutManager.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 24.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MEAttributedLayoutManager.h"
#import "MEAttributedLabel.h"
#import "MEAttributedString.h"


static NSMutableArray *gCachedLabels = nil;


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

- (void)setAttributesToLabel:(UILabel *)aLabel withText:(NSString *)aText
{
    id sValue;

    sValue = [mAttributes objectForKey:MEFontAttributeName];
    if (sValue)
    {
        [aLabel setFont:sValue];
    }
    else
    {
        [aLabel setFont:[UIFont systemFontOfSize:17.0]];
    }

    sValue = [mAttributes objectForKey:MEForegroundColorAttributeName];
    if (sValue)
    {
        [aLabel setTextColor:sValue];
    }
    else
    {
        [aLabel setTextColor:[UIColor blackColor]];
    }

    sValue = [mAttributes objectForKey:MEBackgroundColorAttributeName];
    if (sValue)
    {
        [aLabel setBackgroundColor:sValue];
    }
    else
    {
        [aLabel setBackgroundColor:[UIColor clearColor]];
    }

    sValue = [mAttributes objectForKey:MEHighlightedColorAttributeName];
    if (sValue)
    {
        [aLabel setHighlightedTextColor:sValue];
    }
    else
    {
        [aLabel setHighlightedTextColor:nil];
    }

    sValue = [mAttributes objectForKey:MEShadowColorAttributeName];
    if (sValue)
    {
        [aLabel setShadowColor:sValue];
    }
    else
    {
        [aLabel setShadowColor:nil];
    }

    sValue = [mAttributes objectForKey:MEShadowOffsetAttributeName];
    if (sValue)
    {
        [aLabel setShadowOffset:[sValue CGSizeValue]];
    }
    else
    {
        [aLabel setShadowOffset:CGSizeMake(0, -1)];
    }

    [aLabel setText:[aText substringWithRange:mTextRange]];
    [aLabel setFrame:mLabelFrame];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p> %@ %@ %@", NSStringFromClass([self class]), self, mAttributes, NSStringFromRange(mTextRange), NSStringFromCGRect(mLabelFrame)];
}

- (void)dealloc
{
    [mAttributes release];
    [super dealloc];
}

@end


@implementation MEAttributedLayoutManager

@synthesize layoutSize  = mLayoutSize;
@synthesize layoutWidth = mLayoutWidth;


+ (void)initialize
{
    if (!gCachedLabels)
    {
        gCachedLabels = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
}

+ (void)didReceiveMemoryWarning:(NSNotification *)aNotification
{
    [gCachedLabels removeAllObjects];
}


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
    if ((aWidth > 0) && (aWidth != mLayoutWidth))
    {
        NSAutoreleasePool *sPool;
        NSCharacterSet    *sWhites;
        NSString          *sText;
        NSUInteger         sLen;
        NSUInteger         sLoc;
        CGRect             sRect;
        CGFloat            sWidth;
        CGFloat            sHeight;

        [mLayoutInfos removeAllObjects];
        mLayoutSize  = CGSizeZero;
        mLayoutWidth = aWidth;

        sPool   = [[NSAutoreleasePool alloc] init];
        sWhites = [NSCharacterSet whitespaceCharacterSet];
        sText   = [aString string];
        sLen    = [aString length];
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

            if (sWidth == 0)
            {
                for (; sLoc < NSMaxRange(sRange); sLoc++)
                {
                    if (![sWhites characterIsMember:[sText characterAtIndex:sLoc]])
                    {
                        break;
                    }
                }

                if (sLoc >= NSMaxRange(sRange))
                {
                    continue;
                }
            }

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

    NSArray                *sLabels;
    NSUInteger              sCount;
    NSUInteger              sIndex;

    sText   = [[aLabel attributedText] string];
    sBounds = [aLabel bounds];

    sLabels = [aLabel subviews];
    sCount  = [sLabels count];
    sIndex  = 0;

    for (sLayoutInfo in mLayoutInfos)
    {
        if (CGRectContainsRect(sBounds, [sLayoutInfo labelFrame]))
        {
            if (sIndex < sCount)
            {
                sLabel = [sLabels objectAtIndex:sIndex];
                [sLayoutInfo setAttributesToLabel:sLabel withText:sText];
                sIndex++;
            }
            else
            {
                sLabel = [gCachedLabels lastObject];

                if (sLabel)
                {
                    [sLabel retain];
                    [gCachedLabels removeLastObject];
                }
                else
                {
                    sLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                }

                [sLayoutInfo setAttributesToLabel:sLabel withText:sText];
                [aLabel addSubview:sLabel];
                [sLabel release];
            }
        }
    }

    if (sIndex < sCount)
    {
        for (sLabel in [sLabels subarrayWithRange:NSMakeRange(sIndex, sCount - sIndex)])
        {
            [gCachedLabels addObject:sLabel];
            [sLabel removeFromSuperview];
        }
    }
}

@end
