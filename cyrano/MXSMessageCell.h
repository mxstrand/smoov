//
//  MXSMessageCell.h
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MXSMessage;


@interface MXSMessageCell : UITableViewCell

{
    IBOutlet UILabel *message;
}

-(void) populateWithMessage:(MXSMessage*)message;

@end
