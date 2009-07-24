/*
 *  MEDraft.m
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 24.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import "MEDraft.h"


@implementation MEDraft


@synthesize userID        = mUserID;
@synthesize body          = mBody;
@synthesize tags          = mTags;
@synthesize icon          = mIcon;
@synthesize originalImage = mOriginalImage;
@synthesize editedImage   = mEditedImage;


#pragma mark -


+ (NSString *)filePathWithUserID:(NSString *)aUserID
{
    static NSString *sDocumentDir = nil;

    if (!sDocumentDir)
    {
        NSArray *sDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

        sDocumentDir = [[sDirs objectAtIndex:0] retain];
    }

    return [sDocumentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.draft", aUserID]];
}


#pragma mark -


+ (MEDraft *)lastDraftWithUserID:(NSString *)aUserID
{
    NSData  *sData;
    MEDraft *sDraft;

    sData = [[NSData alloc] initWithContentsOfFile:[self filePathWithUserID:aUserID]];

    if (sData)
    {
        sDraft = [NSKeyedUnarchiver unarchiveObjectWithData:sData];
    }
    else
    {
        sDraft = nil;
    }

    [sData release];

    return sDraft;
}


+ (void)clearLastDraftWithUserID:(NSString *)aUserID
{
    [[NSFileManager defaultManager] removeItemAtPath:[self filePathWithUserID:aUserID] error:NULL];
}


#pragma mark -


- (id)initWithUserID:(NSString *)aUserID
{
    self = [super init];

    if (self)
    {
        mUserID = [aUserID copy];
    }

    return self;
}

- (void)dealloc
{
    [mUserID release];
    [mBody release];
    [mTags release];
    [mOriginalImage release];
    [mEditedImage release];
    [super dealloc];
}


#pragma mark -
#pragma mark NSCoding


- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super init];

    if (self)
    {
        NSData *sImageData;

        mUserID = [[aCoder decodeObjectForKey:@"userID"] retain];
        mBody   = [[aCoder decodeObjectForKey:@"body"] retain];
        mTags   = [[aCoder decodeObjectForKey:@"tags"] retain];
        mIcon   = [aCoder decodeIntegerForKey:@"icon"];

        sImageData = [aCoder decodeObjectForKey:@"originalImage"];

        if (sImageData)
        {
            mOriginalImage = [[UIImage alloc] initWithData:sImageData];
        }

        sImageData = [aCoder decodeObjectForKey:@"editedImage"];

        if (sImageData)
        {
            mEditedImage = [[UIImage alloc] initWithData:sImageData];
        }
        else
        {
            mEditedImage = [mOriginalImage retain];
        }
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:mUserID forKey:@"userID"];
    [aCoder encodeObject:mBody forKey:@"body"];
    [aCoder encodeObject:mTags forKey:@"tags"];
    [aCoder encodeInteger:mIcon forKey:@"icon"];

    if (mOriginalImage)
    {
        [aCoder encodeObject:UIImagePNGRepresentation(mOriginalImage) forKey:@"originalImage"];
    }

    if (mEditedImage && (mEditedImage != mOriginalImage))
    {
        [aCoder encodeObject:UIImagePNGRepresentation(mEditedImage) forKey:@"editedImage"];
    }
}


#pragma mark -


- (void)save
{
    NSData *sData;

    sData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [sData writeToFile:[MEDraft filePathWithUserID:mUserID] atomically:YES];
}


@end
