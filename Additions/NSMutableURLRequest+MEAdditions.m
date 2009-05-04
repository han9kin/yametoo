/*
 *  NSMutableURLRequest+MEAdditions.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "NSMutableURLRequest+MEAdditions.h"
#import "EXF.h"


@implementation NSMutableURLRequest (MEAdditions)


- (BOOL)attachImage:(UIImage *)aImage
{
    BOOL           sResult = NO;
    NSString      *sBoundary    = @"----YAMETOO";
    NSString      *sContentType = [NSString stringWithFormat:@"multipart/form-data, boundary=%@", sBoundary];
    NSMutableData *sPostBody    = [NSMutableData data];
    NSData        *sJpegData;
    NSMutableData *sImageData   = [NSMutableData data];
    
    if (aImage)
    {
        sJpegData = UIImageJPEGRepresentation(aImage, 0.8);
        
/*        EXFJpeg* jpegScanner = [[EXFJpeg alloc] init];
        [jpegScanner scanImageData:sJpegData]; 
        EXFMetaData *sEXFMetaData = [jpegScanner exifMetaData];
        [sEXFMetaData addTagValue:@"Apple Inc."  forKey:[NSNumber numberWithInt:EXIF_Make]];
        [sEXFMetaData addTagValue:[[UIDevice currentDevice] model] forKey:[NSNumber numberWithInt:EXIF_Model]];
        [jpegScanner populateImageData:sImageData];
        [jpegScanner release]; */
        
        [self setHTTPMethod:@"POST"];
        [self setValue:sContentType forHTTPHeaderField:@"Content-type"];
        
        [sPostBody appendData:[[NSString stringWithFormat:@"--%@\r\n", sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [sPostBody appendData:[@"Content-Disposition: form-data; name=\"attachment\"; filename=\"attached_file.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [sPostBody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [sPostBody appendData:sImageData];
        [sPostBody appendData:sJpegData];
        [sPostBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", sBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [self setHTTPBody:sPostBody];
        sResult = YES;
    }
    
    return sResult;
}


@end
