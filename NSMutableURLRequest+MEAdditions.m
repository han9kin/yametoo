/*
 *  NSMutableURLRequest+MEAdditions.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSMutableURLRequest+MEAdditions.h"


@implementation NSMutableURLRequest (MEAdditions)


- (BOOL)attachImage:(UIImage *)aImage
{
    BOOL           sResult = NO;
    NSString      *sBoundary    = @"----YAMETOO";
    NSString      *sContentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", sBoundary];
    NSMutableData *sPostBody    = [NSMutableData data];
    
    if (aImage)
    {
        [sPostBody appendData:[[NSString stringWithFormat:@"--%@\r\n", sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [sPostBody appendData:[@"Content-Disposition: form-data; name=\"attachment\"; filename=\"attached_file\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [sPostBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [sPostBody appendData:UIImageJPEGRepresentation(aImage, 0.8)];
        [sPostBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [self setHTTPMethod:@"POST"];
        [self setValue:sContentType forHTTPHeaderField:@"Content-type"];
        [self setHTTPBody:sPostBody];
        sResult = YES;
    }
    
    return sResult;
}


@end
