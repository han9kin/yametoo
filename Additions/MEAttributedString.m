/*
 *  MEAttributedString.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 20.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MEAttributedString.h"
#import "MEAttributedLayoutManager.h"
#import "MEMutableAttributedString.h"


@interface MEAttributedString (BaseObjectAccessing)
@end

@implementation MEAttributedString (BaseObjectAccessing)

- (CFAttributedStringRef)baseObject
{
    return mBaseObject;
}

- (void)setBaseObject:(CFAttributedStringRef)aObject
{
    mBaseObject = aObject;
}

@end


@implementation MEAttributedString

- (id)initWithoutBaseObject
{
    return [super init];
}

- (void)dealloc
{
    CFRelease(mBaseObject);
    [mLayoutManager release];
    [super dealloc];
}


#pragma mark -
#pragma mark Creating an MEAttibutedString Object

- (id)init
{
    self = [super init];

    if (self)
    {
        [self setBaseObject:CFAttributedStringCreate(NULL, CFSTR(""), NULL)];
    }

    return self;
}

- (id)initWithString:(NSString *)aString
{
    self = [super init];

    if (self)
    {
        [self setBaseObject:CFAttributedStringCreate(NULL, (aString ? (CFStringRef)aString : CFSTR("")), NULL)];
    }

    return self;
}

- (id)initWithAttributedString:(MEAttributedString *)aAttributedString
{
    self = [super init];

    if (self)
    {
        if (aAttributedString)
        {
            [self setBaseObject:CFAttributedStringCreateCopy(NULL, [aAttributedString baseObject])];
        }
        else
        {
            [self setBaseObject:CFAttributedStringCreate(NULL, CFSTR(""), NULL)];
        }
    }

    return self;
}

- (id)initWithString:(NSString *)aString attributes:(NSDictionary *)aAttributes
{
    self = [super init];

    if (self)
    {
        [self setBaseObject:CFAttributedStringCreate(NULL, (aString ? (CFStringRef)aString : CFSTR("")), (CFDictionaryRef)aAttributes)];
    }

    return self;
}


#pragma mark -
#pragma mark Copying Attributed Strings

- (id)copyWithZone:(NSZone *)aZone
{
    return [self retain];
}

- (id)mutableCopyWithZone:(NSZone *)aZone
{
    return [(MEAttributedString *)[MEMutableAttributedString allocWithZone:aZone] initWithAttributedString:self];
}


#pragma mark -
#pragma mark Retrieving Character Information

- (NSString *)string
{
    return (NSString *)CFAttributedStringGetString([self baseObject]);
}

- (NSUInteger)length
{
    return CFAttributedStringGetLength([self baseObject]);
}


#pragma mark -
#pragma mark Retrieving Attribute Information

- (NSDictionary *)attributesAtIndex:(NSUInteger)aIndex effectiveRange:(NSRange *)aRange
{
    return (NSDictionary *)CFAttributedStringGetAttributes([self baseObject], aIndex, (CFRange *)aRange);
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)aIndex longestEffectiveRange:(NSRange *)aRange inRange:(NSRange)aRangeLimit
{
    return (NSDictionary *)CFAttributedStringGetAttributesAndLongestEffectiveRange([self baseObject], aIndex, *(CFRange *)&aRangeLimit, (CFRange *)aRange);
}

- (id)attribute:(NSString *)aAttributeName atIndex:(NSUInteger)aIndex effectiveRange:(NSRange *)aRange
{
    return (id)CFAttributedStringGetAttribute([self baseObject], aIndex, (CFStringRef)aAttributeName, (CFRange *)aRange);
}

- (id)attribute:(NSString *)aAttributeName atIndex:(NSUInteger)aIndex longestEffectiveRange:(NSRange *)aRange inRange:(NSRange)aRangeLimit
{
    return (id)CFAttributedStringGetAttributeAndLongestEffectiveRange([self baseObject], aIndex, (CFStringRef)aAttributeName, *(CFRange *)&aRangeLimit, (CFRange *)aRange);
}


#pragma mark -
#pragma mark Identifying and Comparing Attributed Strings

- (NSUInteger)hash
{
    return CFHash([self baseObject]);
}

- (BOOL)isEqual:(id)aObject
{
    if ([aObject isKindOfClass:[MEAttributedString class]])
    {
        return CFEqual([self baseObject], [aObject baseObject]);
    }
    else
    {
        return NO;
    }
}

- (BOOL)isEqualToAttributedString:(MEAttributedString *)aOtherString
{
    return CFEqual([self baseObject], [aOtherString baseObject]);
}


#pragma mark -
#pragma mark Describing Attributed Strings

- (NSString *)description
{
    CFStringRef  sBaseDescription;
    NSString    *sDescription;

    sBaseDescription = CFCopyDescription([self baseObject]);
    sDescription     = [NSString stringWithFormat:@"<%@: %p> %@", NSStringFromClass([self class]), self, sBaseDescription];
    CFRelease(sBaseDescription);

    return sDescription;
}


#pragma mark -
#pragma mark Extracting a Substring

- (MEAttributedString *)attributedSubstringFromRange:(NSRange)aRange
{
    MEAttributedString *sString = [[[MEAttributedString alloc] init] autorelease];

    [sString setBaseObject:CFAttributedStringCreateWithSubstring(NULL, [self baseObject], *(CFRange *)&aRange)];

    return sString;
}


#pragma mark -
#pragma mark Handling Layout Manager

- (MEAttributedLayoutManager *)layoutManager
{
    return mLayoutManager;
}

- (CGSize)sizeForWidth:(CGFloat)aWidth
{
    if (!mLayoutManager)
    {
        mLayoutManager = [[MEAttributedLayoutManager alloc] init];
    }

    [mLayoutManager layoutAttributedString:self forWidth:aWidth];

    return [mLayoutManager layoutSize];
}


@end


NSString *MEFontAttributeName             = @"MEFont";
NSString *MEForegroundColorAttributeName  = @"MEForegroundColor";
NSString *MEBackgroundColorAttributeName  = @"MEBackgroundColor";
NSString *MEHighlightedColorAttributeName = @"MEHighlightedColor";
NSString *MEShadowColorAttributeName      = @"MEShadowColor";
NSString *MEShadowOffsetAttributeName     = @"MEShadowOffset";
NSString *MELinkAttributeName             = @"MELink";
