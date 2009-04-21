/*
 *  MEMutableAttributedString.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 20.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import "MEAttributedString.h"


@interface MEMutableAttributedString : MEAttributedString
{
}


#pragma mark -
#pragma mark Retrieving Character Information

- (NSMutableString *)mutableString;


#pragma mark -
#pragma mark Changing Characters

- (void)replaceCharactersInRange:(NSRange)aRange withString:(NSString *)aString;
- (void)deleteCharactersInRange:(NSRange)aRange;


#pragma mark -
#pragma mark Changing Attributes

- (void)setAttributes:(NSDictionary *)aAttributes range:(NSRange)aRange;
- (void)addAttribute:(NSString *)aName value:(id)aValue range:(NSRange)aRange;
- (void)addAttributes:(NSDictionary *)aAttributes range:(NSRange)aRange;
- (void)removeAttribute:(NSString *)aName range:(NSRange)aRange;


#pragma mark -
#pragma mark Changing Characters and Attributes

- (void)appendAttributedString:(MEAttributedString *)aAttributedString;
- (void)insertAttributedString:(MEAttributedString *)aAttributedString atIndex:(NSUInteger)aIndex;
- (void)replaceCharactersInRange:(NSRange)aRange withAttributedString:(MEAttributedString *)aAttributedString;
- (void)setAttributedString:(MEAttributedString *)aAttributedString;


#pragma mark -
#pragma mark Grouping Changes

- (void)beginEditing;
- (void)endEditing;


@end
