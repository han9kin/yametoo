/*
 *  METextParser.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 24.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "METextParser.h"
#import "MEMutableAttributedString.h"
#import <libxml/HTMLparser.h>


static void saxStartElement(void *aContext, const xmlChar *aName, const xmlChar **aAttributes)
{
    NSString            *sElementName;
    NSMutableDictionary *sAttributes;

    if (aAttributes)
    {
        sAttributes = [[NSMutableDictionary alloc] init];

        for (; *aAttributes; aAttributes += 2)
        {
            NSString *sKey   = [[NSString alloc] initWithUTF8String:(const char *)*aAttributes];
            NSString *sValue = [[NSString alloc] initWithUTF8String:(const char *)*(aAttributes + 1)];

            [sAttributes setObject:sValue forKey:sKey];
            [sKey release];
            [sValue release];
        }
    }
    else
    {
        sAttributes = nil;
    }

    sElementName = [[NSString alloc] initWithUTF8String:(const char *)aName];
    [(id)aContext parser:nil didStartElement:sElementName namespaceURI:nil qualifiedName:nil attributes:sAttributes];
    [sElementName release];
    [sAttributes release];
}

static void saxEndElement(void *aContext, const xmlChar *aName)
{
    NSString *sElementName;

    sElementName = [[NSString alloc] initWithUTF8String:(const char *)aName];
    [(id)aContext parser:nil didEndElement:sElementName namespaceURI:nil qualifiedName:nil];
    [sElementName release];
}

static void saxCharacters(void *aContext, const xmlChar *aCharacters, int aLength)
{
    NSString *sString;

    sString = [[NSString alloc] initWithBytesNoCopy:(void *)aCharacters length:aLength encoding:NSUTF8StringEncoding freeWhenDone:NO];
    [(id)aContext parser:nil foundCharacters:sString];
    [sString release];
}

static void saxError(void *aContext, const char * msg, ...)
{
    va_list sArgs;

    va_start(sArgs, msg);
    NSLogv([NSString stringWithUTF8String:msg], sArgs);
    va_end(sArgs);
}


static htmlSAXHandler simpleSAXHandlerStruct =
{
    NULL,                       /* internalSubset */
    NULL,                       /* isStandalone   */
    NULL,                       /* hasInternalSubset */
    NULL,                       /* hasExternalSubset */
    NULL,                       /* resolveEntity */
    NULL,                       /* getEntity */
    NULL,                       /* entityDecl */
    NULL,                       /* notationDecl */
    NULL,                       /* attributeDecl */
    NULL,                       /* elementDecl */
    NULL,                       /* unparsedEntityDecl */
    NULL,                       /* setDocumentLocator */
    NULL,                       /* startDocument */
    NULL,                       /* endDocument */
    saxStartElement,            /* startElement*/
    saxEndElement,              /* endElement */
    NULL,                       /* reference */
    saxCharacters,              /* characters */
    NULL,                       /* ignorableWhitespace */
    NULL,                       /* processingInstruction */
    NULL,                       /* comment */
    NULL,                       /* warning */
    saxError,                   /* error */
    NULL,                       /* fatalError: unused error() get all the errors */
    NULL,                       /* getParameterEntity */
    NULL,                       /* cdataBlock */
    NULL,                       /* externalSubset */
    XML_SAX2_MAGIC,
    NULL,
    NULL,                       /* startElementNs */
    NULL,                       /* endElementNs */
    NULL,                       /* serror */
};


@implementation METextParser

- (id)init
{
    self = [super init];

    if (self)
    {
        mAttributedString = [[MEMutableAttributedString alloc] init];
        mAttributesStack  = [[NSMutableArray alloc] init];
        mCurrentString    = [[NSMutableString alloc] init];
    }

    return self;
}

- (void)dealloc
{
    [mAttributedString release];
    [mAttributesStack release];
    [mCurrentString release];
    [super dealloc];
}

- (MEAttributedString *)attributedString
{
    return mAttributedString;
}

- (NSDictionary *)defaultAttributes
{
    return nil;
}

- (void)flushCurrentString
{
    NSArray            *sWords;
    NSString           *sString;
    MEAttributedString *sAttributedString;

    sWords = [mCurrentString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ([sWords count] > 2)
    {
        sWords = [[sWords mutableCopy] autorelease];
        [(NSMutableArray *)sWords removeObject:@"" inRange:NSMakeRange(1, [sWords count] - 2)];
    }

    sString = [sWords componentsJoinedByString:@" "];

    if ([sString length])
    {
        sAttributedString = [[MEAttributedString alloc] initWithString:sString attributes:[mAttributesStack lastObject]];
        [mAttributedString appendAttributedString:sAttributedString];
        [sAttributedString release];
    }

    [mCurrentString setString:@""];
}


+ (MEAttributedString *)attributedStringFromString:(NSString *)aString
{
    NSAutoreleasePool  *sPool;
    NSData             *sData;
    METextParser       *sHandler;
    MEAttributedString *sResult;
    htmlParserCtxtPtr   sContext;

    sPool    = [[NSAutoreleasePool alloc] init];
    sData    = [[NSString stringWithFormat:@"<p>%@</p>", aString] dataUsingEncoding:NSUTF8StringEncoding];
    sHandler = [[[self alloc] init] autorelease];
    sContext = htmlCreatePushParserCtxt(&simpleSAXHandlerStruct, sHandler, NULL, 0, NULL, XML_CHAR_ENCODING_UTF8);

    htmlParseChunk(sContext, (const char *)[sData bytes], [sData length], 1);

    sResult = [[sHandler attributedString] copy];

    htmlFreeParserCtxt(sContext);

    [sPool release];

    return [sResult autorelease];
}


#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser *)aParser didStartElement:(NSString *)aElementName namespaceURI:(NSString *)aNamespaceURI qualifiedName:(NSString *)aQualifiedName attributes:(NSDictionary *)aAttributes
{
}

- (void)parser:(NSXMLParser *)aParser didEndElement:(NSString *)aElementName namespaceURI:(NSString *)aNamespaceURI qualifiedName:(NSString *)aQualifiedName
{
}

- (void)parser:(NSXMLParser *)aParser foundCharacters:(NSString *)aString
{
}


@end
