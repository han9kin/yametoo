/*
 *  MEPostBodyTextParser.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 24.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEPostBodyTextParser.h"
#import "MEMutableAttributedString.h"


static NSDictionary *gDefaultAttributes = nil;
static NSDictionary *gLinkAttributes    = nil;


@implementation MEPostBodyTextParser

+ (void)initialize
{
    if (!gDefaultAttributes)
    {
        gDefaultAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:14], MEFontAttributeName, [UIColor colorWithWhite:0.13 alpha:1.0], MEForegroundColorAttributeName, [UIColor whiteColor], MEHighlightedColorAttributeName, nil];
    }

    if (!gLinkAttributes)
    {
        gLinkAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor colorWithRed:0.90 green:0.35 blue:0.01 alpha:1.0], MEForegroundColorAttributeName, [UIColor colorWithWhite:0.85 alpha:1.0], MEHighlightedColorAttributeName, nil];
    }
}

- (NSDictionary *)defaultAttributes
{
    return gDefaultAttributes;
}


#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser *)aParser didStartElement:(NSString *)aElementName namespaceURI:(NSString *)aNamespaceURI qualifiedName:(NSString *)aQualifiedName attributes:(NSDictionary *)aAttributes
{
    NSMutableDictionary *sAttributes;

    [self flushCurrentString];

    sAttributes = [NSMutableDictionary dictionaryWithDictionary:[mAttributesStack lastObject]];

    if ([aElementName isEqualToString:@"a"] && [aAttributes objectForKey:@"href"])
    {
        [sAttributes addEntriesFromDictionary:gLinkAttributes];
        [sAttributes setObject:[aAttributes objectForKey:@"href"] forKey:MELinkAttributeName];
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
