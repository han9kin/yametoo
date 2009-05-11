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
    UIFont   *sFont  = [UIFont systemFontOfSize:17];
    NSString *sStr   = [NSString stringWithFormat:NSLocalizedString(@"%d character(s) remains", nil), (mLimitCount - [sBody length])];
    CGSize    sSize  = [sStr sizeWithFont:sFont];
    CGRect    sFrame;
    
    sSize.width  += 10;
    sSize.height += 6;
    
    UIGraphicsBeginImageContext(sSize);
    [[UIColor orangeColor] set];
    MERoundRectFill(CGRectMake(0, 0, sSize.width, sSize.height), 3);
    
    [[UIColor blackColor] set];
    [sStr drawAtPoint:CGPointMake(5, 5) withFont:sFont];
    
    sImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    sFrame = CGRectMake(320 - sSize.width - 23, 191, sSize.width, sSize.height);
    
    [mLayer setOpacity:0.7];
    [mLayer setContents:(id)[sImage CGImage]];
    [mLayer setFrame:sFrame];
}


@end
