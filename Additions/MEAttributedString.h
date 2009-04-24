/*
 *  MEAttributedString.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 20.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@class MEAttributedLayoutManager;

@interface MEAttributedString : NSObject
{
    CFTypeRef                  mBaseObject;
    MEAttributedLayoutManager *mLayoutManager;
}


#pragma mark -
#pragma mark Creating an MEAttibutedString Object

- (id)initWithString:(NSString *)aString;
- (id)initWithAttributedString:(MEAttributedString *)aAttributedString;
- (id)initWithString:(NSString *)aString attributes:(NSDictionary *)aAttributes;


#pragma mark -
#pragma mark Retrieving Character Information

- (NSString *)string;
- (NSUInteger)length;


#pragma mark -
#pragma mark Retrieving Attribute Information

- (NSDictionary *)attributesAtIndex:(NSUInteger)aIndex effectiveRange:(NSRange *)aRange;
- (NSDictionary *)attributesAtIndex:(NSUInteger)aIndex longestEffectiveRange:(NSRange *)aRange inRange:(NSRange)aRangeLimit;
- (id)attribute:(NSString *)aAttributeName atIndex:(NSUInteger)aIndex effectiveRange:(NSRange *)aRange;
- (id)attribute:(NSString *)aAttributeName atIndex:(NSUInteger)aIndex longestEffectiveRange:(NSRange *)aRange inRange:(NSRange)aRangeLimit;


#pragma mark -
#pragma mark Comparing Attributed Strings

- (BOOL)isEqualToAttributedString:(MEAttributedString *)aOtherString;


#pragma mark -
#pragma mark Extracting a Substring

- (MEAttributedString *)attributedSubstringFromRange:(NSRange)aRange;


#pragma mark -
#pragma mark Handling Layout Manager

- (MEAttributedLayoutManager *)layoutManager;
- (CGSize)sizeForWidth:(CGFloat)aWidth;


@end


#pragma mark -
#pragma mark Attributes

extern NSString *MEFontAttributeName;                // UIFont, default system font at a size of 17 points
extern NSString *MEForegroundColorAttributeName;     // UIColor, default blackColor
extern NSString *MEBackgroundColorAttributeName;     // UIColor, default nil: no background
extern NSString *MEHighlightedColorAttributeName;    // UIColor, default nil: no highlighted
extern NSString *MEShadowColorAttributeName;         // UIColor, default nil: no shadow
extern NSString *MEShadowOffsetAttributeName;        // NSValue containing CGSize, default (0, -1)
extern NSString *MELinkAttributeName;                // NSURL (preferred) or NSString
