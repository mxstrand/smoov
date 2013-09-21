//
//  MXSMessageCell.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSMessageCell.h"
#import "MXSMessage.h"

@implementation MXSMessageCell

-(void) populateWithMessage:(MXSMessage*)messagex
{
    self->message.text = messagex.content;
}

@end
