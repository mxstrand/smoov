//
//  MXSFlirtViewController.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSSorryViewController.h"
#import "MXSMessage.h"

@implementation MXSSorryViewController

- (void) loadMessages
{
    messages = [NSMutableArray new];
    NSLog(@"messages being loaded");
    
    MXSMessage *message = [MXSMessage new];
    message.content = @"I've been thinking about our discussion and you were totally right.";
    message.popularityImage = 5;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I was dropped a lot as a baby. That must explain why I did that. Sorry.";
    message.popularityImage = 2;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I'm going to invent a new word....sorryouweright.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"You are always right. I'm sorry I questioned you.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Thanks for not beating me up. I was being a dork.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Basically, I'm not that smart. Sorry.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"If I can give you 7 hugs in under 5 seconds, will you forgive me?";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I've been thinking about what happened, and I'm really sorry.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I called and it IS legally possible to change my name to stoopid-head. Should I make the appointment?";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Can we hold peace talks tonight? I'm sorry.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I'm sorry I said I liked your sister's yoga pants.";
    message.popularityImage = 3;
    [messages addObject:message];

}

@end