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
    const char   *sCStr = [self UTF8String];  
    unsigned char sResult[CC_MD5_DIGEST_LENGTH];  

    CC_MD5(sCStr, strlen(sCStr), sResult);  

    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",  
                                      sResult[0], sResult[1], sResult[2],  sResult[3],  sResult[4],  sResult[5],  sResult[6],  sResult[7],  
                                      sResult[8], sResult[9], sResult[10], sResult[11], sResult[12], sResult[13], sResult[14], sResult[15]];  
}

@end
