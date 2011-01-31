/*
 *  MEPhotoViewController.h
 *  yametoo
 *
 *  Created by han9kin on 09. 07. 16.
 *  Copyright 2009 yametoo. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEImageButton;
@class MEPost;

@interface MEPhotoViewController : UIViewController
{
    MEImageButton           *mImageButton;
    UINavigationBar         *mNavigationBar;
    UILabel                 *mTextLabel;
    UIActivityIndicatorView *mActivityIndicator;

    MEPost                  *mPost;
}

@property(nonatomic, assign) IBOutlet MEImageButton           *imageButton;
@property(nonatomic, assign) IBOutlet UINavigationBar         *navigationBar;
@property(nonatomic, assign) IBOutlet UILabel                 *textLabel;
@property(nonatomic, assign) IBOutlet UIActivityIndicatorView *activityIndicator;


- (id)initWithPost:(MEPost *)aPost;


- (IBAction)imageDidLoad;
- (IBAction)toggleControls;
- (IBAction)close;

@end
