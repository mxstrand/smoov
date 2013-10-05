//
//  MXSFlirtViewController.m
//  cyrano
//
//  Created by Michael Strand on 9/20/13.
//  Copyright (c) 2013 Michael Strand. All rights reserved.
//

#import "MXSLuckyViewController.h"
#import "MXSMessage.h"

@implementation MXSLuckyViewController

- (void) loadMessages
{
    messages = [NSMutableArray new];
    NSLog(@"messages being loaded");
    
    MXSMessage *message = [MXSMessage new];
    message.content = @"Let's light some candles tonight during dinner.";
    message.popularityImage = 5;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Quit cleaning the oven and give me some lovin.";
    message.popularityImage = 2;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I'm thinking about your perfume right now.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Do you prefer a back rub or a foot massage?";
    message.popularityImage = 2;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Let's listen to some Marvyn Gaye tonight.";
    message.popularityImage = 5;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Hey, where's a good place to buy oysters?";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"What are you going to wear for halloween? I bet it's gonna look good.";
    message.popularityImage = 2;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"We should stay in a hotel one night just for fun.";
    message.popularityImage = 4;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I want you to Snapchat me something racey for my birthday.";
    message.popularityImage = 5;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Mondays are so boring, Snapchat me something risky.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Do you think silk sheets would be fun?";
    message.popularityImage = 2;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"My birthday suit just got back from the cleaners!";
    message.popularityImage = 1;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Hey, is that 7 Shades of Grey book any good?";
    message.popularityImage = 3;
    [messages addObject:message];

    
}

@end