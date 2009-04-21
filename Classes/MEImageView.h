/*
 *  MEImageView.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 21.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface MEImageView : UIView
{
    UIImage  *mImage;
    NSString *mKey;
}

- (void)setImageWithURL:(NSURL *)aURL;

@end
