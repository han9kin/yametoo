/*
 *  NSMutableArray+MEAdditions.h
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 21.
 *  Copyright 2009 NHN. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface NSMutableArray (MEAdditions)

- (void)moveObjectAtIndex:(NSUInteger)aFromIndex toIndex:(NSUInteger)aToIndex;

@end
