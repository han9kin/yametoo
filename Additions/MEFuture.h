/*
 *  MEFuture.h
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 20.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@interface NSObject (MEFuture)

- (BOOL)isFuture;

@end


@interface MEFuture : NSObject
{

}

+ (id)future;

@end
