//
//  MXSFlirtViewController.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSFlirtViewController.h"
#import "MXSMessage.h"

@interface MXSFlirtViewController ()

@end

@implementation MXSFlirtViewController

- (void) loadMessages
{
    messages = [NSMutableArray new];
    NSLog(@"messages being loaded");
    
    MXSMessage *message = [MXSMessage new];
    message.content = @"I'm thinking about running for president. Wanna be VP or first lady?";
    message.popularityImage = 5;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"If my friends wouldn't kill me, I'd ditch them to come be with you.";
    message.popularityImage = 2;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Let's reenact the scene in Armageddon where A.J. prances an Animal Cracker on Grace’s belly";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"How often do you go to the gym - you look great.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"If I won the lottery, I'd buy you a house to hold all the purses I would buy you.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I bet you are going to do awesome at work today.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Flirt";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Flirt";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Flirt";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Flirt";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Flirt";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Flirt";
    message.popularityImage = 3;
    [messages addObject:message];

}


@end