/*
 *  MEMutableAttributedString.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 20.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEMutableAttributedString.h"


NSString *MEFontAttributeName            = @"MEFont";
NSString *MEForegroundColorAttributeName = @"MEForegroundColor";
NSString *MEBackgroundColorAttributeName = @"MEBackgroundColor";
NSString *MEShadowColorAttributeName     = @"MEShadowColor";
NSString *MEShadowOffsetAttributeName    = @"MEShadowOffset";
NSString *MELinkAttributeName            = @"MELink";


@interface MEAttributedString (Private)

- (CFMutableAttributedStringRef)baseObject;
- (void)setBaseObject:(CFMutableAttributedStringRef)aObject;

@end


@implementation MEMutableAttributedString


#pragma mark -
#pragma mark Creating an MEMutableAttibutedString Object

- (id)init
{
    self = [super init];

    if (self)
    {
        [self setBaseObject:CFAttributedStringCreateMutable(NULL, 0)];
    }

    return self;
}

- (id)initWithString:(NSString *)aString
{
    self = [super init];

    if (self)
    {
        if (aString)
        {
            CFAttributedStringRef sAttributedString;

            sAttributedString = CFAttributedStringCreate(NULL, (CFStringRef)aString, NULL);
            [self setBaseObject:CFAttributedStringCreateMutableCopy(NULL, 0, sAttributedString)];
            CFRelease(sAttributedString);
        }
        else
        {
            [self setBaseObject:CFAttributedStringCreateMutable(NULL, 0)];
        }
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
            [self setBaseObject:CFAttributedStringCreateMutableCopy(NULL, 0, [aAttributedString baseObject])];
        }
        else
        {
            [self setBaseObject:CFAttributedStringCreateMutable(NULL, 0)];
        }
    }

    return self;
}

- (id)initWithString:(NSString *)aString attributes:(NSDictionary *)aAttributes
{
    self = [super init];

    if (self)
    {
        if (aString)
        {
            CFAttributedStringRef sAttributedString;

            sAttributedString = CFAttributedStringCreate(NULL, (CFStringRef)aString, (CFDictionaryRef)aAttributes);
            [self setBaseObject:CFAttributedStringCreateMutableCopy(NULL, 0, sAttributedString)];
            CFRelease(sAttributedString);
        }
        else
        {
            [self setBaseObject:CFAttributedStringCreateMutable(NULL, 0)];
        }
    }

    return self;
}


#pragma mark -
#pragma mark Copying Attributed Strings

- (id)copyWithZone:(NSZone *)aZone
{
    return [(MEAttributedString *)[MEAttributedString allocWithZone:aZone] initWithAttributedString:self];
}

- (id)mutableCopyWithZone:(NSZone *)aZone
{
    return [(MEAttributedString *)[MEMutableAttributedString allocWithZone:aZone] initWithAttributedString:self];
}


#pragma mark -
#pragma mark Retrieving Character Information

- (NSMutableString *)mutableString
{
    return (NSMutableString *)CFAttributedStringGetMutableString([self baseObject]);
}


#pragma mark -
#pragma mark Changing Characters

- (void)replaceCharactersInRange:(NSRange)aRange withString:(NSString *)aString
{
    CFAttributedStringReplaceString([self baseObject], *(CFRange *)&aRange, (aString ? (CFStringRef)aString : CFSTR("")));
}

- (void)deleteCharactersInRange:(NSRange)aRange
{
    CFAttributedStringReplaceString([self baseObject], *(CFRange *)&aRange, CFSTR(""));
}


#pragma mark -
#pragma mark Changing Attributes

- (void)setAttributes:(NSDictionary *)aAttributes range:(NSRange)aRange
{
    CFAttributedStringSetAttributes([self baseObject], *(CFRange *)&aRange, (CFDictionaryRef)aAttributes, true);
}

- (void)addAttribute:(NSString *)aName value:(id)aValue range:(NSRange)aRange
{
    CFAttributedStringSetAttribute([self baseObject], *(CFRange *)&aRange, (CFStringRef)aName, aValue);
}

- (void)addAttributes:(NSDictionary *)aAttributes range:(NSRange)aRange
{
    CFAttributedStringSetAttributes([self baseObject], *(CFRange *)&aRange, (CFDictionaryRef)aAttributes, false);
}

- (void)removeAttribute:(NSString *)aName range:(NSRange)aRange
{
    CFAttributedStringRemoveAttribute([self baseObject], *(CFRange *)&aRange, (CFStringRef)aName);
}


#pragma mark -
#pragma mark Changing Characters and Attributes

- (void)appendAttributedString:(MEAttributedString *)aAttributedString
{
    if (aAttributedString)
    {
        CFAttributedStringReplaceAttributedString([self baseObject], CFRangeMake([self length], 0), [aAttributedString baseObject]);
    }
}

- (void)insertAttributedString:(MEAttributedString *)aAttributedString atIndex:(NSUInteger)aIndex
{
    if (aAttributedString)
    {
        CFAttributedStringReplaceAttributedString([self baseObject], CFRangeMake(aIndex, 0), [aAttributedString baseObject]);
    }
}

- (void)replaceCharactersInRange:(NSRange)aRange withAttributedString:(MEAttributedString *)aAttributedString
{
    if (aAttributedString)
    {
        CFAttributedStringReplaceAttributedString([self baseObject], *(CFRange *)&aRange, [aAttributedString baseObject]);
    }
    else
    {
        CFAttributedStringReplaceString([self baseObject], *(CFRange *)&aRange, CFSTR(""));
    }
}

- (void)setAttributedString:(MEAttributedString *)aAttributedString
{
    if (aAttributedString)
    {
        CFAttributedStringReplaceAttributedString([self baseObject], CFRangeMake(0, [self length]), [aAttributedString baseObject]);
    }
    else
    {
        CFAttributedStringReplaceString([self baseObject], CFRangeMake(0, [self length]), CFSTR(""));
    }
}


#pragma mark -
#pragma mark Grouping Changes

- (void)beginEditing
{
    CFAttributedStringBeginEditing([self baseObject]);
}

- (void)endEditing
{
    CFAttributedStringEndEditing([self baseObject]);
}


@end
