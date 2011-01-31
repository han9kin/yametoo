/*
 *  METextParser.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 24.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@class MEAttributedString;
@class MEMutableAttributedString;

@interface METextParser : NSObject
{
    MEMutableAttributedString *mAttributedString;

    NSMutableArray            *mAttributesStack;
    NSMutableString           *mCurrentString;
}

+ (MEAttributedString *)attributedStringFromString:(NSString *)aString;

- (void)flushCurrentString;

@end
