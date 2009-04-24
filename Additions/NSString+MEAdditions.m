/*
 *  NSString+MEAdditions.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <commoncrypto/commondigest.h>
#import "NSString+MEAdditions.h"


@implementation NSString (Additions)

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

- (NSString *)stringByReplacingCharacterEntities
{
    NSMutableString *sResult;
    NSString        *sKey;
    NSString        *sRep;
    NSRange          sRangeAmp;
    NSRange          sRangeEnd;
    unichar          sChar;
    int              sCopyLoc;
    int              sLastLoc;
    int              sLength;

    sResult  = nil;
    sCopyLoc = 0;
    sLastLoc = 0;
    sLength  = [self length];

    while (sLastLoc < sLength)
    {
        sRangeEnd = [self rangeOfString:@";" options:NSLiteralSearch range:NSMakeRange(sLastLoc, sLength - sLastLoc)];

        if (sRangeEnd.location == NSNotFound)
        {
            break;
        }

        if ((sRangeEnd.location - sLastLoc) > 1)
        {
            sRangeAmp = [self rangeOfString:@"&" options:(NSBackwardsSearch | NSLiteralSearch) range:NSMakeRange(sLastLoc, sRangeEnd.location - sLastLoc - 1)];

            if ((sRangeAmp.location != NSNotFound) && ((sRangeEnd.location - sRangeAmp.location) > 1))
            {
                sKey = [self substringWithRange:NSMakeRange(sRangeAmp.location + 1, sRangeEnd.location - sRangeAmp.location - 1)];

                if ([sKey hasPrefix:@"#"])
                {
                    if ([sKey length] > 1)
                    {
                        sChar = [[sKey substringFromIndex:1] intValue];
                        sRep  = [NSString stringWithCharacters:&sChar length:1];
                    }
                    else
                    {
                        sRep = nil;
                    }
                }
                else
                {
                    sRep = NSLocalizedStringFromTable(sKey, @"CharacterEntity", nil);
                }

                if (sRep && (sRep != sKey))
                {
                    if (!sResult)
                    {
                        sResult = [NSMutableString string];
                    }

                    [sResult appendString:[self substringWithRange:NSMakeRange(sCopyLoc, sRangeAmp.location - sCopyLoc)]];
                    [sResult appendString:sRep];

                    sCopyLoc = sRangeEnd.location + 1;
                }
            }
        }

        sLastLoc = sRangeEnd.location + 1;
    }

    if (sResult)
    {
        if (sCopyLoc < sLength)
        {
            [sResult appendString:[self substringFromIndex:sCopyLoc]];
        }

        return sResult;
    }
    else
    {
        return self;
    }
}

@end
