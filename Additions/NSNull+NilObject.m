/*
 *  NSNull+NilObject.m
 *  yametoo
 *
 *  Created by han9kin on 09. 04. 15.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>


@implementation NSNull (NilObject)

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
