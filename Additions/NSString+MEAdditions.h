/*
 *  NSString+MEAdditions.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface NSString (MEAdditions)

- (NSString *)md5String;

- (NSString *)stringByReplacingCharacterEntities;

- (NSString *)stringByAddingPercentEscapes;

@end
