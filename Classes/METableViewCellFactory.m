/*
 *  METableViewCellFactory.m
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 17.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import "ObjCUtil.h"
#import "UIColor+MEAdditions.h"
#import "METableViewCellFactory.h"
#import "MEImageView.h"
#import "MEPostBodyView.h"
#import "MEAttributedLabel.h"
#import "MEClientStore.h"
#import "MEClient.h"
#import "MEUser.h"
#import "MEPost.h"


enum
{
    kImageTag = 1,
    kTitleTag,
    kDetailTag,
    kTextFieldTag,
    kCheckmarkTag,
    kLockIconTag,

    kPostFaceImageTag,
    kPostIconTag,
    kPostAuthorLabelTag,
    kPostBodyTag,

    kCommentFaceImageFrameTag,
    kCommentFaceImageTag,
    kCommentBodyTag,
};


@implementation METableViewCellFactory


#pragma mark -
#pragma mark - Class Methods


+ (UITableViewCell *)defaultCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Default"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Default"] autorelease];
    }

    return sCell;

}


+ (UITableViewCell *)detailCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UILabel         *sLabel;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Detail"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Detail"] autorelease];

        [sCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 43)];
        [sLabel setTag:kTitleTag];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sLabel setTextAlignment:UITextAlignmentLeft];
        [sLabel setTextColor:[UIColor blackColor]];
        [sLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 260, 43)];
        [sLabel setTag:kDetailTag];
        [sLabel setBackgroundColor:[UIColor clearColor]];
        [sLabel setFont:[UIFont systemFontOfSize:17.0]];
        [sLabel setTextAlignment:UITextAlignmentRight];
        [sLabel setTextColor:[UIColor selectedTextColor]];
        [sLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];
    }

    return sCell;
}


+ (UITableViewCell *)textFieldCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UILabel         *sLabel;
    UITextField     *sTextField;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"TextField"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"TextField"] autorelease];

        [sCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 100, 21)];
        [sLabel setTag:kTitleTag];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sTextField = [[UITextField alloc] initWithFrame:CGRectMake(120, 6, 180, 31)];
        [sTextField setTag:kTextFieldTag];
        [sTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [sTextField setBorderStyle:UITextBorderStyleNone];
        [sTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [sTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [sTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [sTextField setEnablesReturnKeyAutomatically:YES];
        [[sCell contentView] addSubview:sTextField];
        [sTextField release];
    }

    return sCell;
}


+ (UITableViewCell *)switchCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UISwitch        *sSwitch;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Switch"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Switch"] autorelease];

        [sCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        sSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sCell setAccessoryView:sSwitch];
        [sSwitch release];
    }

    return sCell;
}


+ (UITableViewCell *)buttonCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Button"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Button"] autorelease];

        [sCell setTextAlignment:UITextAlignmentCenter];
    }

    return sCell;
}


+ (UITableViewCell *)userCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    MEImageView     *sFaceImageView;
    UIView          *sFrameView;
    UILabel         *sUserIDLabel;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"User"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"User"] autorelease];

        sFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 52, 52)];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [[sCell contentView] addSubview:sFrameView];
        [sFrameView release];

        sFaceImageView = [[MEImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [sFaceImageView setTag:kImageTag];
        [[sCell contentView] addSubview:sFaceImageView];
        [sFaceImageView release];

        sUserIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 180, 30)];
        [sUserIDLabel setTag:kTitleTag];
        [sUserIDLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sUserIDLabel setTextColor:[UIColor blackColor]];
        [sUserIDLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sUserIDLabel];
        [sUserIDLabel release];
    }

    return sCell;
}


+ (UITableViewCell *)clientCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UIButton        *sButton;
    UILabel         *sLabel;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Client"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Client"] autorelease];

        [sCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];

        sButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sButton setTag:kCheckmarkTag];
        [sButton setFrame:CGRectMake(10, 15, 14, 14)];
        [[sCell contentView] addSubview:sButton];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 210, 21)];
        [sLabel setTag:kTitleTag];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sButton setTag:kLockIconTag];
        [sButton setFrame:CGRectMake(245, 14, 11, 15)];
        [[sCell contentView] addSubview:sButton];
    }

    return sCell;
}


+ (UITableViewCell *)postCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UIView          *sFrameView;
    MEImageView     *sImageView;
    MEPostBodyView  *sBodyView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Post"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Post"] autorelease];

        sFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding - 1, 46, 46)];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [[sCell contentView] addSubview:sFrameView];
        [sFrameView release];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(8, kPostCellBodyPadding, kIconImageSize, kIconImageSize)];
        [sImageView setTag:kPostIconTag];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];

        sBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 250, 0)];
        [sBodyView setTag:kPostBodyTag];
        [[sCell contentView] addSubview:sBodyView];
        [sBodyView release];
    }

    return sCell;
}


+ (UITableViewCell *)postCellWithAuthorForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UIView          *sFrameView;
    UILabel         *sLabel;
    MEImageView     *sImageView;
    MEPostBodyView  *sBodyView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Post"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Post"] autorelease];

        sFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding - 1, 46, 46)];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [[sCell contentView] addSubview:sFrameView];
        [sFrameView release];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(8, kPostCellBodyPadding, kIconImageSize, kIconImageSize)];
        [sImageView setTag:kPostFaceImageTag];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];

        sFrameView = [[UIImageView alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding + 49, 46, 46)];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [[sCell contentView] addSubview:sFrameView];
        [sFrameView release];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(8, kPostCellBodyPadding + 50, kIconImageSize, kIconImageSize)];
        [sImageView setTag:kPostIconTag];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 250, 15)];
        [sLabel setTag:kPostAuthorLabelTag];
        [sLabel setFont:[UIFont systemFontOfSize:12.0]];
        [sLabel setTextColor:[UIColor darkGrayColor]];
        [sLabel setHighlightedTextColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding + 20, 250, 0)];
        [sBodyView setTag:kPostBodyTag];
        [[sCell contentView] addSubview:sBodyView];
        [sBodyView release];
    }

    return sCell;
}


+ (UITableViewCell *)commentCellForTableView:(UITableView *)aTableView
{
    UITableViewCell   *sCell;
    UIView            *sFrameView;
    MEImageView       *sImageView;
    MEAttributedLabel *sBodyLabel;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Comment"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Comment"] autorelease];

        sBodyLabel = [[MEAttributedLabel alloc] initWithFrame:CGRectZero];
        [sBodyLabel setTag:kCommentBodyTag];
        [[sCell contentView] addSubview:sBodyLabel];
        [sBodyLabel release];

        sFrameView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [sFrameView setTag:kCommentFaceImageFrameTag];
        [sFrameView setBackgroundColor:[UIColor lightGrayColor]];
        [[sCell contentView] addSubview:sFrameView];
        [sFrameView release];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(1, 1, kIconImageSize, kIconImageSize)];
        [sImageView setTag:kCommentFaceImageTag];
        [sFrameView addSubview:sImageView];
        [sImageView release];
    }

    return sCell;
}


@end


#pragma mark -
#pragma mark UITableViewCell Additions for Content Accessing


@implementation UITableViewCell (ContentAccessing)


- (void)setDisabled:(BOOL)aDisabled
{
    if (aDisabled)
    {
        [self setTextColor:[UIColor lightGrayColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    else
    {
        [self setTextColor:[UIColor blackColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
}


- (void)setTitleText:(NSString *)aText
{
    [(UILabel *)[[self contentView] viewWithTag:kTitleTag] setText:aText];
}


- (void)setDetailText:(NSString *)aText
{
    [(UILabel *)[[self contentView] viewWithTag:kDetailTag] setText:aText];
}


- (UITextField *)textField;
{
    return (UITextField *)[[self contentView] viewWithTag:kTextFieldTag];
}


- (UISwitch *)switch
{
    return (UISwitch *)[self accessoryView];
}


- (void)setUser:(MEUser *)aUser
{
    [(MEImageView *)[[self contentView] viewWithTag:kImageTag] setImageWithURL:[aUser faceImageURL]];
    [(UILabel *)[[self contentView] viewWithTag:kTitleTag] setText:[aUser userID]];
}


- (void)setClient:(MEClient *)aClient
{
    UILabel  *sLabel     = (UILabel *)[[self contentView] viewWithTag:kTitleTag];
    UIButton *sCheckmark = (UIButton *)[[self contentView] viewWithTag:kCheckmarkTag];
    UIButton *sLockIcon  = (UIButton *)[[self contentView] viewWithTag:kLockIconTag];

    [sLabel setText:[aClient userID]];

    if (aClient == [MEClientStore currentClient])
    {
        [sCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_normal.png"] forState:UIControlStateNormal];
        [sCheckmark setBackgroundImage:[UIImage imageNamed:@"checkmark_highlighted.png"] forState:UIControlStateHighlighted];
        [sLabel setTextColor:[UIColor selectedTextColor]];
    }
    else
    {
        [sCheckmark setBackgroundImage:nil forState:UIControlStateNormal];
        [sCheckmark setBackgroundImage:nil forState:UIControlStateHighlighted];
        [sLabel setTextColor:[UIColor blackColor]];
    }

    if ([aClient hasPasscode])
    {
        [sLockIcon setBackgroundImage:[UIImage imageNamed:@"locked_normal.png"] forState:UIControlStateNormal];
        [sLockIcon setBackgroundImage:[UIImage imageNamed:@"locked_highlighted.png"] forState:UIControlStateHighlighted];
    }
    else
    {
        [sLockIcon setBackgroundImage:nil forState:UIControlStateNormal];
        [sLockIcon setBackgroundImage:nil forState:UIControlStateHighlighted];
    }
}


- (void)setPost:(MEPost *)aPost withTarget:(id)aTarget
{
    UILabel        *sLabel;
    MEImageView    *sImageView;
    MEPostBodyView *sBodyView;

    sLabel = (UILabel *)[[self contentView] viewWithTag:kPostAuthorLabelTag];
    [sLabel setText:[[aPost author] nickname]];

    sImageView = (MEImageView *)[[self contentView] viewWithTag:kPostFaceImageTag];
    [sImageView addTarget:aTarget action:@selector(faceImageViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[sImageView userInfo] setValue:[aPost author] forKey:@"author"];
    [sImageView setImageWithURL:[[aPost author] faceImageURL]];

    sImageView = (MEImageView *)[[self contentView] viewWithTag:kPostIconTag];
    [sImageView addTarget:aTarget action:@selector(iconImageViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [[sImageView userInfo] setValue:aPost forKey:@"post"];
    [sImageView setImageWithURL:[aPost iconURL]];

    sBodyView = (MEPostBodyView *)[[self contentView] viewWithTag:kPostBodyTag];
    [sBodyView setPost:aPost];
}


- (void)setComment:(MEComment *)aComment isOwners:(BOOL)aOwners
{
    MEAttributedLabel *sBodyLabel  = (MEAttributedLabel *)[[self contentView] viewWithTag:kCommentBodyTag];
    MEImageView       *sImageView  = (MEImageView *)[[self contentView] viewWithTag:kCommentFaceImageTag];
    UIView            *sImageFrame = (UIView *)[[self contentView] viewWithTag:kCommentFaceImageFrameTag];

    if (aOwners)
    {
        [sBodyLabel setFrame:CGRectMake(10, 10, kCommentBodyWidth, 0)];
        [sImageFrame setFrame:CGRectMake(265, 9, kIconImageSize + 2, kIconImageSize + 2)];
    }
    else
    {
        [sBodyLabel setFrame:CGRectMake(70, 10, kCommentBodyWidth, 0)];
        [sImageFrame setFrame:CGRectMake(9, 9, kIconImageSize + 2, kIconImageSize + 2)];
    }

    [sBodyLabel setAttributedText:[aComment body]];
    [sBodyLabel sizeToFit];

    [sImageView setImageWithURL:[[aComment author] faceImageURL]];
}


@end
