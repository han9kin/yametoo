/*
 *  MEObjCUtil.m
 *  yametoo
 *
 *  Created by han9kin on 09. 02. 19.
 *  Copyright 2008 NHN Corp. All rights reserved.
 *
 */


#pragma mark making singleton class


#define SYNTHESIZE_SINGLETON_CLASS(aClassName, aAccessor) SYNTHESIZE_SINGLETON_CLASS_WITH_RETURNTYPE(aClassName, aClassName *, aAccessor)

#define SYNTHESIZE_SINGLETON_CLASS_WITH_RETURNTYPE(aClassName, aReturnType, aAccessor)  \
                                                                                        \
    static aClassName *aAccessor = nil;                                                 \
                                                                                        \
+ (aReturnType)aAccessor                                                                \
{                                                                                       \
    @synchronized(self)                                                                 \
    {                                                                                   \
        if (!aAccessor)                                                                 \
        {                                                                               \
            [[self alloc] init];                                                        \
        }                                                                               \
    }                                                                                   \
                                                                                        \
    return aAccessor;                                                                   \
}                                                                                       \
                                                                                        \
+ (id)allocWithZone:(NSZone *)aZone                                                     \
{                                                                                       \
    @synchronized(self)                                                                 \
    {                                                                                   \
        if (!aAccessor)                                                                 \
        {                                                                               \
            aAccessor = [super allocWithZone:aZone];                                    \
            return aAccessor;                                                           \
        }                                                                               \
    }                                                                                   \
                                                                                        \
    return nil;                                                                         \
}                                                                                       \
                                                                                        \
- (id)copyWithZone:(NSZone *)aZone                                                      \
{                                                                                       \
    return self;                                                                        \
}                                                                                       \
                                                                                        \
- (id)retain                                                                            \
{                                                                                       \
    return self;                                                                        \
}                                                                                       \
                                                                                        \
- (NSUInteger)retainCount                                                               \
{                                                                                       \
    return NSUIntegerMax;                                                               \
}                                                                                       \
                                                                                        \
- (void)release                                                                         \
{                                                                                       \
}                                                                                       \
                                                                                        \
- (id)autorelease                                                                       \
{                                                                                       \
    return self;                                                                        \
}
