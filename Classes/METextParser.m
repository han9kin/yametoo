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

+ (MEAttributedString *)attributedStringFromString:(NSString *)aString
{
    NSAutoreleasePool  *sPool;
    NSData             *sData;
    NSXMLParser        *sParser;
    METextParser       *sHandler;
    MEAttributedString *sResult;

    sPool    = [[NSAutoreleasePool alloc] init];
    aString  = [aString stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    sData    = [[NSString stringWithFormat:@"<text>%@</text>", aString] dataUsingEncoding:NSUTF8StringEncoding];
    sParser  = [[[NSXMLParser alloc] initWithData:sData] autorelease];
    sHandler = [[[self alloc] init] autorelease];

    [sParser setDelegate:sHandler];

    if ([sParser parse])
    {
        sResult = [[sHandler attributedString] copy];
    }
    else
    {
        NSLog(@"%@", [sParser parserError]);
        sResult = [[MEAttributedString alloc] initWithString:aString attributes:[sHandler defaultAttributes]];
    }

    [sPool release];

    return [sResult autorelease];
}

@end
