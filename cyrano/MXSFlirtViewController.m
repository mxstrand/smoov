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
    message.content = @"I'd totally populate Mars with you.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I just decided to have 6-pack abs by Christmas, so you probably want to get on this train now.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I bought a Groupon for professional Photoshopping. Want to merge our photos and see what our kids will look like?.";
    message.popularityImage = 3;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"I'm thinking about running for president. Wanna be VP or first lady?";
    message.popularityImage = 5;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"If my friends wouldn't kill me, I'd ditch them to come be with you.";
    message.popularityImage = 2;
    [messages addObject:message];
    
    message = [MXSMessage new];
    message.content = @"Let's reenact the scene in Armageddon where the guy prances an animal cracker on the girl's stomach.";
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
    message.content = @"Hey baby, you smell like a fancy candle.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I need a medically-induced coma to get you off my mind.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I love your eyes, and hair, and neck, and...mind.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"Baby, your eyes glow like a beautiful alien.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I bet I could beat you in a crab-walking race.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"If we were dinosaurs, I'd want to cuddle with you through the ice age.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I hear Lionel Ritchie music in my mind every time I think about you.";
    message.popularityImage = 3;
    [messages addObject:message];

    message = [MXSMessage new];
    message.content = @"I just named my wifi network after you.";
    message.popularityImage = 3;
    [messages addObject:message];

}


@end