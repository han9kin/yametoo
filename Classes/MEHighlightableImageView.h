/*
 *  MEHighlightableImageView.h
 *  yametoo
 *
 *  Created by han9kin on 09. 05. 08.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEHighlightableImageView : UIView
{
    UIImage     *mNormalImage;
    UIImage     *mHighlightedImage;

    BOOL         mHighlighted;
}

@property(nonatomic, retain)               UIImage *normalImage;
@property(nonatomic, retain)               UIImage *highlightedImage;
@property(nonatomic, getter=isHighlighted) BOOL     highlighted;


@end
