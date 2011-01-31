/*
 *  MEDrawingFunctions.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 27.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import "MEDrawingFunctions.h"


static void MERoundRectDraw(CGRect aRect, float aRoundVal, BOOL aIsFill)
{
    float sLeft = aRect.origin.x;
    float sTop = aRect.origin.y;
    float sRight = aRect.origin.x + aRect.size.width;
    float sBottom = aRect.origin.y + aRect.size.height;
    float sRound = aRoundVal;
    float sLong = sRound - (sRound / 6);
    float sShort = sRound / 6;

    CGContextRef sContext = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint(sContext, sLeft, sTop + sRound);
    CGContextAddCurveToPoint(sContext, sLeft, sTop + sLong, sLeft + sShort, sTop, sLeft + sRound, sTop);
    CGContextAddLineToPoint(sContext, sRight - sRound, sTop);
    CGContextAddCurveToPoint(sContext, sRight - sLong, sTop, sRight, sTop + sShort, sRight, sTop + sRound);
    CGContextAddLineToPoint(sContext, sRight, sBottom - sRound);
    CGContextAddCurveToPoint(sContext, sRight, sBottom - sLong, sRight - sShort, sBottom, sRight - sRound, sBottom);
    CGContextAddLineToPoint(sContext, sLeft + sRound, sBottom);
    CGContextAddCurveToPoint(sContext, sLeft + sLong, sBottom, sLeft, sBottom - sShort, sLeft, sBottom - sRound);
    CGContextAddLineToPoint(sContext, sLeft, sTop + sRound);

    if (aIsFill)
    {
        CGContextFillPath(sContext);
    }
    else
    {
        CGContextStrokePath(sContext);
    }
}


void MERoundRectFill(CGRect aRect, float aRoundVal)
{
    MERoundRectDraw(aRect, aRoundVal, YES);
}


void MERoundRectStroke(CGRect aRect, float aRoundVal)
{
    MERoundRectDraw(aRect, aRoundVal, NO);
}
