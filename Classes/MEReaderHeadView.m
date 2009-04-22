/*
 *  MEReaderHeadView.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "MEReaderHeadView.h"


@implementation MEReaderHeadView


- (id)initWithFrame:(CGRect)aFrame
{
    CGRect sFrame;
    
    self = [super initWithFrame:aFrame];
    if (self)
    {
        [self setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:1.0]];
        
        {
            mFaceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            
            sFrame.size.width  = kFaceImageViewWidth;
            sFrame.size.height = kFaceImageViewHeight;
            sFrame.origin.x    = 7;
            sFrame.origin.y    = 10;
            [mFaceImageView setFrame:sFrame];
            [mFaceImageView setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
            
            [self addSubview:mFaceImageView];
        }
        
        {
            mNicknameButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
            [mNicknameButton setTitle:@"#User Nickname#" forState:UIControlStateNormal];
            [mNicknameButton addTarget:self action:@selector(nicknameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            sFrame.size.width  = kNickButtonWidth;
            sFrame.size.height = kNickButtonHeight;
            sFrame.origin.x    = 65;
            sFrame.origin.y    = (int)((aFrame.size.height - sFrame.size.height ) / 2);
            [mNicknameButton setFrame:sFrame];
            
            [self addSubview:mNicknameButton];
        }
        
        {
            mNewPostButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
            [mNewPostButton setTitle:NSLocalizedString(@"New Post", nil) forState:UIControlStateNormal];
            [mNewPostButton addTarget:self action:@selector(newPostButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            sFrame.size.width  = kPostButtonWidth;
            sFrame.size.height = kPostButtonHeight;
            sFrame.origin.x    = 225;
            sFrame.origin.y    = (int)((aFrame.size.height - sFrame.size.height ) / 2);
            [mNewPostButton setFrame:sFrame];
            
            [self addSubview:mNewPostButton];
        }
    }

    return self;
}
            

- (void)drawRect:(CGRect)aRect
{

}

            
- (void)dealloc
{
    [mFaceImageView  release];
    [mNicknameButton release];
    [mNewPostButton  release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Class Method


+ (MEReaderHeadView *)readerHeadView
{
    MEReaderHeadView *sResult;
    
    sResult = [[[MEReaderHeadView alloc] initWithFrame:CGRectMake(0, 0, 320, kReaderHeadViewHeight)] autorelease];
    return sResult;
}


#pragma mark -
#pragma mark Instance Method


- (void)setNickname:(NSString *)aNickname
{
    [mNicknameButton setTitle:[NSString stringWithFormat:@"%@'s me2day", aNickname] forState:UIControlStateNormal];
}


- (void)setFaceImage:(UIImage *)aFaceImage
{
    if ([aFaceImage isKindOfClass:[UIImage class]])
    {
        [mFaceImageView setImage:aFaceImage];
    }
}


- (void)setHiddenPostButton:(BOOL)aFlag
{
    [mNewPostButton setHidden:aFlag];
}


#pragma mark -
#pragma mark Actions


- (IBAction)nicknameButtonTapped:(id)aSender
{
    NSLog(@"nicknameButtonTapped");
}


- (IBAction)newPostButtonTapped:(id)aSender
{
    NSLog(@"newPostButtonTapped");
}


@end
