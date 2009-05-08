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
#import "MEHighlightableImageView.h"
#import "MEImageView.h"
#import "MEImageButton.h"
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
    UILabel         *sLabel;
    MEImageView     *sImageView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"User"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"User"] autorelease];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(9, 9, 52, 52)];
        [sImageView setBorderColor:[UIColor lightGrayColor]];
        [sImageView setTag:kImageTag];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 180, 69)];
        [sLabel setTag:kTitleTag];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sLabel setTextColor:[UIColor blackColor]];
        [sLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];
    }

    return sCell;
}


+ (UITableViewCell *)clientCellForTableView:(UITableView *)aTableView
{
    UITableViewCell          *sCell;
    UILabel                  *sLabel;
    MEHighlightableImageView *sImageView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Client"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Client"] autorelease];

        [sCell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];

        sImageView = [[MEHighlightableImageView alloc] initWithFrame:CGRectMake(10, 15, 14, 14)];
        [sImageView setTag:kCheckmarkTag];
        [sImageView setHidden:YES];
        [sImageView setNormalImage:[UIImage imageNamed:@"checkmark_normal.png"]];
        [sImageView setHighlightedImage:[UIImage imageNamed:@"checkmark_highlighted.png"]];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 11, 210, 21)];
        [sLabel setTag:kTitleTag];
        [sLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [sLabel setHighlightedTextColor:[UIColor whiteColor]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sImageView = [[MEHighlightableImageView alloc] initWithFrame:CGRectMake(245, 14, 11, 15)];
        [sImageView setTag:kLockIconTag];
        [sImageView setHidden:YES];
        [sImageView setNormalImage:[UIImage imageNamed:@"locked_normal.png"]];
        [sImageView setHighlightedImage:[UIImage imageNamed:@"locked_highlighted.png"]];
        [[sCell contentView] addSubview:sImageView];
        [sImageView release];
    }

    return sCell;
}


+ (UITableViewCell *)postCellForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    MEImageButton   *sImageButton;
    MEPostBodyView  *sBodyView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Post"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Post"] autorelease];

        sImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding - 1, kIconImageSize + 2, kIconImageSize + 2)];
        [sImageButton setBorderColor:[UIColor lightGrayColor]];
        [sImageButton setTag:kPostIconTag];
        [[sCell contentView] addSubview:sImageButton];
        [sImageButton release];

        sBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 0, 0)];
        [sBodyView setTag:kPostBodyTag];
        [[sCell contentView] addSubview:sBodyView];
        [sBodyView release];
    }

    return sCell;
}


+ (UITableViewCell *)postCellWithAuthorForTableView:(UITableView *)aTableView
{
    UITableViewCell *sCell;
    UILabel         *sLabel;
    MEImageButton   *sImageButton;
    MEPostBodyView  *sBodyView;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Post"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Post"] autorelease];

        sImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding - 1, kIconImageSize + 2, kIconImageSize + 2)];
        [sImageButton setTag:kPostFaceImageTag];
        [sImageButton setBorderColor:[UIColor lightGrayColor]];
        [[sCell contentView] addSubview:sImageButton];
        [sImageButton release];

        sImageButton = [[MEImageButton alloc] initWithFrame:CGRectMake(7, kPostCellBodyPadding + 49, kIconImageSize + 2, kIconImageSize + 2)];
        [sImageButton setTag:kPostIconTag];
        [sImageButton setBorderColor:[UIColor lightGrayColor]];
        [[sCell contentView] addSubview:sImageButton];
        [sImageButton release];

        sLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding, 250, 15)];
        [sLabel setTag:kPostAuthorLabelTag];
        [sLabel setFont:[UIFont systemFontOfSize:12.0]];
        [sLabel setTextColor:[UIColor darkGrayColor]];
        [sLabel setHighlightedTextColor:[UIColor colorWithWhite:0.9 alpha:1.0]];
        [[sCell contentView] addSubview:sLabel];
        [sLabel release];

        sBodyView = [[MEPostBodyView alloc] initWithFrame:CGRectMake(60, kPostCellBodyPadding + 20, 0, 0)];
        [sBodyView setTag:kPostBodyTag];
        [[sCell contentView] addSubview:sBodyView];
        [sBodyView release];
    }

    return sCell;
}


+ (UITableViewCell *)commentCellForTableView:(UITableView *)aTableView
{
    UITableViewCell   *sCell;
    MEImageView       *sImageView;
    MEAttributedLabel *sBodyLabel;

    sCell = [aTableView dequeueReusableCellWithIdentifier:@"Comment"];

    if (!sCell)
    {
        sCell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"Comment"] autorelease];

        [sCell setSelectionStyle:UITableViewCellSelectionStyleNone];

        sBodyLabel = [[MEAttributedLabel alloc] initWithFrame:CGRectZero];
        [sBodyLabel setTag:kCommentBodyTag];
        [[sCell contentView] addSubview:sBodyLabel];
        [sBodyLabel release];

        sImageView = [[MEImageView alloc] initWithFrame:CGRectMake(0, 0, kIconImageSize + 2, kIconImageSize + 2)];
        [sImageView setBorderColor:[UIColor lightGrayColor]];
        [sImageView setTag:kCommentFaceImageTag];
        [[sCell contentView] addSubview:sImageView];
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


- (void)setUserID:(NSString *)aUserID
{
    [(MEImageView *)[[self contentView] viewWithTag:kImageTag] setImageWithURL:nil];
    [(UILabel *)[[self contentView] viewWithTag:kTitleTag] setText:aUserID];
}


- (void)setClient:(MEClient *)aClient
{
    UILabel *sLabel     = (UILabel *)[[self contentView] viewWithTag:kTitleTag];
    UIView  *sCheckmark = [[self contentView] viewWithTag:kCheckmarkTag];
    UIView  *sLockIcon  = [[self contentView] viewWithTag:kLockIconTag];

    [sLabel setText:[aClient userID]];

    if (aClient == [MEClientStore currentClient])
    {
        [sCheckmark setHidden:NO];
        [sLabel setTextColor:[UIColor selectedTextColor]];
    }
    else
    {
        [sCheckmark setHidden:YES];
        [sLabel setTextColor:[UIColor blackColor]];
    }

    if ([aClient hasPasscode])
    {
        [sLockIcon setHidden:NO];
    }
    else
    {
        [sLockIcon setHidden:YES];
    }
}


- (void)setPost:(MEPost *)aPost withTarget:(id)aTarget
{
    UILabel        *sLabel;
    MEImageButton  *sImageButton;
    MEPostBodyView *sBodyView;

    sLabel = (UILabel *)[[self contentView] viewWithTag:kPostAuthorLabelTag];
    [sLabel setText:[[aPost author] nickname]];

    sImageButton = (MEImageButton *)[[self contentView] viewWithTag:kPostFaceImageTag];
    [sImageButton addTarget:aTarget action:@selector(faceImageViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [sImageButton setUserInfo:[aPost author]];
    [sImageButton setImageWithURL:[[aPost author] faceImageURL]];

    sImageButton = (MEImageButton *)[[self contentView] viewWithTag:kPostIconTag];
    [sImageButton addTarget:aTarget action:@selector(iconImageViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [sImageButton setUserInfo:aPost];
    [sImageButton setImageWithURL:[aPost iconURL]];

    sBodyView = (MEPostBodyView *)[[self contentView] viewWithTag:kPostBodyTag];
    [sBodyView setPost:aPost];
}


- (void)setComment:(MEComment *)aComment isOwners:(BOOL)aOwners
{
    MEImageView       *sImageView  = (MEImageView *)[[self contentView] viewWithTag:kCommentFaceImageTag];
    MEAttributedLabel *sBodyLabel  = (MEAttributedLabel *)[[self contentView] viewWithTag:kCommentBodyTag];

    if (aOwners)
    {
        [sImageView setFrame:CGRectMake(265, 9, kIconImageSize + 2, kIconImageSize + 2)];
        [sBodyLabel setFrame:CGRectMake(10, 10, kCommentBodyWidth, 0)];
    }
    else
    {
        [sImageView setFrame:CGRectMake(9, 9, kIconImageSize + 2, kIconImageSize + 2)];
        [sBodyLabel setFrame:CGRectMake(70, 10, kCommentBodyWidth, 0)];
    }

    [sImageView setImageWithURL:[[aComment author] faceImageURL]];

    [sBodyLabel setAttributedText:[aComment body]];
    [sBodyLabel sizeToFit];
}


@end
