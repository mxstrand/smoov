//
//  MXSMessageReversalViewController.h
//  cyrano
//
//  Created by Michael Strand on 10/17/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXSMessage.h"

@interface MXSMessageReversalViewController : UIViewController
{
    IBOutlet UILabel *messageLabel;
    IBOutlet UILabel *authorLabel;
    IBOutlet UIImageView *visualPopularityImage;
    IBOutlet UIImageView *profileImage;
}

@property (nonatomic, weak) MXSMessage *message;

@end
