/*
 *  MEFuture.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 20.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MEFuture.h"
#import "ObjCUtil.h"


@implementation NSObject (MEFuture)

- (BOOL)isFuture
{
    return NO;
}

@end


@implementation MEFuture

SYNTHESIZE_SINGLETON_CLASS_WITH_RETURNTYPE(MEFuture, id, future);


- (BOOL)isFuture
{
    return YES;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [NSMethodSignature signatureWithObjCTypes:"@@:"];
}

- (void)forwardInvocation:(NSInvocation *)aInvocation
{
    id sRet = nil;

    [aInvocation setReturnValue:&sRet];
}

@end
