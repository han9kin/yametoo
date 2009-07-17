/*
 *  MECharCounter.m
 *  yametoo
 *
 *  Created by cgkim on 09. 05. 11.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MECharCounter.h"
#import "MEDrawingFunctions.h"


#define BEGIN_ANIMATION_OFF()       [CATransaction begin]; \
                                    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
#define END_ANIMATION_OFF()         [CATransaction commit];


@implementation MECharCounter


- (id)initWithParentView:(UIView *)aParentView;
{
    self = [super init];
    if (self)
    {
        mLayer = [[CALayer layer] retain];
        [mLayer setHidden:YES];
        
        [[aParentView layer] addSublayer:mLayer];
    }
    return self;
}


- (void)dealloc
{
    [mLayer     removeFromSuperlayer];
    [mLayer     release];
    [mTextOwner release];
    
    [super dealloc];
}


#pragma mark -


- (void)setLimitCount:(NSInteger)aLimitCount
{
    mLimitCount = aLimitCount;
}


- (NSInteger)limitCount
{
    return mLimitCount;
}


- (void)setTextOwner:(id)aTextOwner
{
    [mTextOwner autorelease];
    mTextOwner = [aTextOwner retain];
}


- (void)setHidden:(BOOL)aFlag
{
    [mLayer setHidden:aFlag];
}


- (void)setFrame:(CGRect)aFrame
{
    [mLayer setFrame:aFrame];
}


- (void)update
{
    UIImage  *sImage = nil;
    NSString *sBody  = [mTextOwner text];
    UIFont   *sFont  = [UIFont boldSystemFontOfSize:30];
    NSInteger sRemainCount = (mLimitCount - [sBody length]);
    NSString *sStr   = [NSString stringWithFormat:@"%d", sRemainCount];
    CGSize    sSize  = [sStr sizeWithFont:sFont];
    CGRect    sFrame;

    sSize.width  += 10;
    sSize.height += 6;
    
    UIGraphicsBeginImageContext(sSize);
    
    if (sRemainCount < 10)
    {
        [[UIColor orangeColor] set];
    }
    else
    {
        [[UIColor grayColor] set];
    }
    
    [sStr drawAtPoint:CGPointMake(5, 5) withFont:sFont];
    
    sImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    sFrame = [mLayer frame];
    sFrame = CGRectMake(320 - sSize.width - 23, sFrame.origin.y, sSize.width, sSize.height);

    BEGIN_ANIMATION_OFF();
    [mLayer setOpacity:0.8];
    [mLayer setContents:(id)[sImage CGImage]];
    [mLayer setFrame:sFrame];
    END_ANIMATION_OFF();
}


@end
