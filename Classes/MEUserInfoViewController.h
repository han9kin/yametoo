/*
 *  MEUserInfoViewController.h
 *  yametoo
 *
 *  Created by cgkim on 09. 04. 28.
 *  Copyright 2009 NHN Corp. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@class MEUser;


@interface MEUserInfoViewController : UIViewController
{
    IBOutlet UILabel *mPhoneTextLabel;
    IBOutlet UILabel *mEmailTextLabel;
    IBOutlet UILabel *mMessengerTextLabel;
    IBOutlet UILabel *mHomepageTextLabel;
    IBOutlet UILabel *mPhoneContLabel;
    IBOutlet UILabel *mEmailContLabel;
    IBOutlet UILabel *mMessengerContLabel;
    IBOutlet UILabel *mHomepageContLabel;
    
    MEUser *mUser;
}

@property (nonatomic, retain) MEUser *user;

- (IBAction)closeButtonTapped:(id)aSender;

@end
