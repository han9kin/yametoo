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
        gDefaultAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:12], MEFontAttributeName, [UIColor darkGrayColor], MEForegroundColorAttributeName, [UIColor whiteColor], MEHighlightedColorAttributeName, nil];
    }

    if (!gLinkAttributes)
    {
        gLinkAttributes = [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor orangeColor], MEForegroundColorAttributeName, [UIColor whiteColor], MEHighlightedColorAttributeName, nil];
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
