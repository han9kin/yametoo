/*
 *  NSString+MEAdditions.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <commoncrypto/commondigest.h>
#import "NSString+MEAdditions.h"


@implementation NSString (MEAdditions)


- (NSString *)md5String
{
    const char    *sUTF8String;
    unsigned char  sResult[CC_MD5_DIGEST_LENGTH];

    sUTF8String = [self UTF8String];
    CC_MD5(sUTF8String, strlen(sUTF8String), sResult);

    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                                      sResult[0], sResult[1], sResult[2],  sResult[3],  sResult[4],  sResult[5],  sResult[6],  sResult[7],
                                      sResult[8], sResult[9], sResult[10], sResult[11], sResult[12], sResult[13], sResult[14], sResult[15]];
}


- (NSString *)stringByAddingPercentEscapes
{
    return [(id)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, CFSTR("!$&'()*+,-./:;=?@_~[]#"), kCFStringEncodingUTF8) autorelease];
}


- (NSUInteger)lengthMe2DAY
{
    NSAutoreleasePool *sPool;
    NSUInteger         sTotalLength;
    NSUInteger         sLength;
    NSUInteger         sIndex;
    unichar            sChar;

    enum
    {
        kStateNormal,
        kStateQuoteStarted,
        kStateQuoteEnded,
        kStateLinkStarted,
    } sState;

    sTotalLength = [self length];
    sLength      = 0;
    sState       = kStateNormal;

    for (sIndex = 0; sIndex < sTotalLength; sIndex++)
    {
        sPool = [[NSAutoreleasePool alloc] init];
        sChar = [self characterAtIndex:sIndex];

        switch (sChar)
        {
            case '"':
                if (sState == kStateNormal)
                {
                    sState = kStateQuoteStarted;
                }
                else if (sState == kStateQuoteStarted)
                {
                    sState = kStateQuoteEnded;
                }
                break;

            case ':':
                if (sState == kStateQuoteEnded)
                {
                    NSString *sString = [self substringFromIndex:(sIndex + 1)];

                    if ([sString hasPrefix:@"http://"])
                    {
                        sIndex  += 8;
                        sLength -= 2;
                        sState   = kStateLinkStarted;
                    }
                    else if ([sString hasPrefix:@"https://"])
                    {
                        sIndex  += 9;
                        sLength -= 2;
                        sState   = kStateLinkStarted;
                    }
                    else
                    {
                        sState = kStateNormal;
                    }
                }
                break;

            case ' ':
            case '\t':
                if (sState == kStateLinkStarted)
                {
                    sState = kStateNormal;
                    sLength--;
                }
                break;

            default:
                if (sState == kStateQuoteEnded)
                {
                    sState = kStateNormal;
                }
                break;
        }

        if (sState != kStateLinkStarted)
        {
            sLength++;
        }

        [sPool release];
    }

    return sLength;
}


@end
