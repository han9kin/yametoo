/*
 *  MECommentBodyTextParser.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MECommentBodyTextParser.h"
#import "MEMutableAttributedString.h"


static NSDictionary *gDefaultAttributes = nil;
static NSDictionary *gLinkAttributes    = nil;


@implementation MECommentBodyTextParser

+ (void)initialize
{
    if (!gDefaultAttributes)
    {
        gDefaultAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:14], MEFontAttributeName, [UIColor darkGrayColor], MEForegroundColorAttributeName, [UIColor whiteColor], MEHighlightedColorAttributeName, nil];
    }

    if (!gLinkAttributes)
    {
        gLinkAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.90 green:0.35 blue:0.01 alpha:1.0], MEForegroundColorAttributeName, [UIColor whiteColor], MEHighlightedColorAttributeName, nil];
    }
}

- (NSDictionary *)defaultAttributes
{
    return gDefaultAttributes;
}

- (void)flushCurrentString
{
    if ([mCurrentString length])
    {
        [mAttributedString appendAttributedString:[[[MEAttributedString alloc] initWithString:mCurrentString attributes:[mAttributesStack lastObject]] autorelease]];
        [mCurrentString setString:@""];
    }
}


#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser *)aParser didStartElement:(NSString *)aElementName namespaceURI:(NSString *)aNamespaceURI qualifiedName:(NSString *)aQualifiedName attributes:(NSDictionary *)aAttributes
{
    NSMutableDictionary *sAttributes;

    [self flushCurrentString];

    sAttributes = [NSMutableDictionary dictionaryWithDictionary:[mAttributesStack lastObject]];

    if ([aElementName isEqualToString:@"a"])
    {
        [sAttributes addEntriesFromDictionary:gLinkAttributes];
    }
    else
    {
        [sAttributes addEntriesFromDictionary:gDefaultAttributes];
    }

    [mAttributesStack addObject:sAttributes];
}

- (void)parser:(NSXMLParser *)aParser didEndElement:(NSString *)aElementName namespaceURI:(NSString *)aNamespaceURI qualifiedName:(NSString *)aQualifiedName
{
    [self flushCurrentString];

    [mAttributesStack removeLastObject];
}

- (void)parser:(NSXMLParser *)aParser foundCharacters:(NSString *)aString
{
    [mCurrentString appendString:aString];
}

@end
