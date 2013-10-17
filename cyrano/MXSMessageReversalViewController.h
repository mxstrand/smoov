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
    IBOutlet UIImageView *visualPopularityImage;
}

@property (nonatomic, weak) MXSMessage *message;

@end
